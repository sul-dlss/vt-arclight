# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include Arclight::SearchBehavior

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end

  ##
  # @overriding arclight to change the hl.fl field
  # Add highlighting
  def add_highlighting(solr_params)
    solr_params['hl'] = true
    solr_params['hl.fl'] = 'full_text_tesimv'
    solr_params['hl.snippets'] = 3
    solr_params
  end
end
