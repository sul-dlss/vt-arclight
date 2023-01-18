# frozen_string_literal: true

# Handles submission of the feedback form
class FeedbacksController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def create
    if verify_recaptcha(action: 'feedback')
      FeedbackMailer.submit_feedback(name: params[:name], email: params[:email],
                                     reporting_from: params[:reporting_from],
                                     message: params[:message]).deliver_now
      redirect_to root_path, notice: t(".success")
    else
      # Score is below threshold, so user may be a bot.
      redirect_to root_path, alert: t(".failure")
    end
  end
  # rubocop:enable Metrics/AbcSize
end
