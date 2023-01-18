# frozen_string_literal: true

# Creates feedback emails
class FeedbackMailer < ApplicationMailer
  def submit_feedback(name:, email:, reporting_from:, message:)
    @name = name
    @email = email
    @reporting_from = reporting_from
    @message = message
    mail(to: Rails.application.config.feedback_email,
         from: 'no-reply@library.stanford.edu')
  end
end
