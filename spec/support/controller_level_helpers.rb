# frozen_string_literal: true

module ControllerLevelHelpers
  module ControllerViewHelpers
    def search_state
      @search_state ||= Blacklight::SearchState.new({}, blacklight_config, controller)
    end

    def search_action_path(params)
      search_catalog_path(params.to_h)
    end

    def blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(controller)
    end

    def blacklight_config
      @blacklight_config ||= Blacklight::Configuration.new
    end
  end

  def initialize_controller_helpers(helper)
    helper.extend ControllerViewHelpers
  end
end
