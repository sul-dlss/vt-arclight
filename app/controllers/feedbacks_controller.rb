# frozen_string_literal: true

# Handles submission of the feedback form
class FeedbacksController < ApplicationController
  def create
    FeedbackMailer.submit_feedback(name: params[:name], email: params[:email], message: params[:message]).deliver_now
    redirect_to root_path, notice: t(".success")
  end
end
