# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  mount Blacklight::Engine => '/'
  mount Arclight::Engine => '/'

  root to: "virtual_tribunals#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/nuremberg', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new
  concern :hierarchy, Arclight::Routes::Hierarchy.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :hierarchy
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resource :feedback, only: :create
end
