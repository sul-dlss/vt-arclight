# frozen_string_literal: true

# Draws the front page
class VirtualTribunalsController < ApplicationController
  def index; end

  # This is the content of the <title> tag
  def render_page_title
    t('virtual_tribunals.header_component.title')
  end
  helper_method :render_page_title
end
