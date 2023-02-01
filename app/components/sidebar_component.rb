# frozen_string_literal: true

# Overrides the collection_context method from Arclight so that we can use our own download_component
class SidebarComponent < Arclight::SidebarComponent
  def collection_context
    render Arclight::CollectionContextComponent.new(presenter: document_presenter(document),
                                                    download_component: DocumentDownloadComponent)
  end
end
