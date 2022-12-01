# frozen_string_literal: true

require 'traject/solr_json_writer'

module Traject
  # A custom SolrJsonWriter that breaks apart large collection hierarchies into manageable sized
  # requests for Solr.
  class AtomicSolrWriter < ::Traject::SolrJsonWriter
    # Send each collection to Solr in one or more requests. Because Arclight puts all the components of a collection
    # in one document, we need to decompose it into multiple requests (of a reasonable number of docs).
    def send_batch(batch)
      # Arclight documents are the whole tree, so let's not try to batch them across collections
      batch.each do |collection|
        json_package = collection.output_hash

        slice_graph(json_package).each do |subgraph|
          # Convert these to a stub traject context so we can use the existing solr_json_writer
          batch_operations = subgraph.map do |doc|
            Traject::Indexer::Context.new.tap { |context| context.output_hash = doc }
          end

          super(batch_operations)
        end
      end
    end

    private

    def nested_documents_property
      @settings.fetch('nested_documents_property', 'components')
    end

    def atomic_update_parent_id_field
      @settings.fetch('atomic_update_parent_id_field', 'parent_id_ssi')
    end

    def batch_size
      @settings.fetch('batch_size', 100)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def slice_graph(graph, size: batch_size)
      return to_enum(:slice_graph, graph, size:) unless block_given?

      # Chunk the graph into manageable sized pieces, sorting by the document position
      # in the XML to keep everything in order
      traverse(graph).sort_by { |d| d['sort_isi']&.first || -1 }.each_slice(size).each do |components|
        # We need to do some bookkeeping to make sure any sub-components we've handled aren't also set separately
        handled = {}

        subgraph = components.map do |item|
          next if handled.key?(item['id'].first)

          # The original documents may contain sub-components outside this current chunk. We need to remove them.
          doc = prune(item, to: components)

          handled = handled.merge(traverse(doc).to_h { |d| [d['id'].first, true] })

          # if it's a top-level component, we don't need to do atomic updates and can just send the (pruned) collection
          next doc unless doc[atomic_update_parent_id_field]

          # ... but, if this components has a parent, we need to use atomic updates to add it to the parent
          {
            'id' => doc[atomic_update_parent_id_field],
            '_root_' => graph['id'],
            'text' => { set: nil }, # this is a stored copy field, so we want to erase its stored data
            nested_documents_property => {
              add: [doc]
            }
          }
        end

        # There might be documents with the same parent; we can save some effort by
        # grouping them into a single atomic update 'add'
        subgraph = subgraph.compact.group_by { |d| d['id'].first }.flat_map do |_id, docs|
          next docs if docs.length == 1

          doc = docs.first.dup

          doc[nested_documents_property] = {
            add: docs.flat_map { |d| d.dig(nested_documents_property, :add) || d[nested_documents_property] }
          }

          doc
        end

        yield subgraph
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # Filter the sub-graph to a given list of components
    def prune(doc, to: [])
      return doc unless doc[nested_documents_property]

      doc = doc.dup

      # because we're dealing with an ordered list of components, we only need to
      # have special handling for the last child component (which may have truncated children)
      *children, last_child = doc[nested_documents_property].select do |c|
        to.include?(c)
      end

      last_child &&= prune(last_child, to:)

      doc[nested_documents_property] = children + [last_child].compact

      doc
    end

    # Traverse the document graph through the given property and yield every component
    def traverse(doc, &)
      return to_enum(:traverse, doc) unless block_given?

      yield doc

      doc[nested_documents_property]&.each do |component|
        traverse(component, &)
      end
    end
  end
end
