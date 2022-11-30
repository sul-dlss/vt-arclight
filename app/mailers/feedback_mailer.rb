# frozen_string_literal: true

# Creates feedback emails
class FeedbackMailer < ApplicationMailer
  def submit_feedback(name:, email:, message:)
    @name = name
    @email = email
    @message = message
    mail(to: Rails.application.config.feedback_email,
         from: 'no-reply@library.stanford.edu')
  end
end
