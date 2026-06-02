# frozen_string_literal: true

## CIDR blocks treated as local/exempt from challenges
SAFELIST = [
  '171.64.0.0/14',
  '10.0.0.0/8',
  '172.16.0.0/12'
].freeze

BotChallengePage.configure do |config|
  # If disabled, no challenges will be issued
  config.enabled = ENV.fetch('TURNSTILE_ENABLED', 'false').downcase == 'true'

  # Get from CloudFlare Turnstile: https://www.cloudflare.com/application-services/products/turnstile/
  # Some testing keys are also available: https://developers.cloudflare.com/turnstile/troubleshooting/testing/
  #
  # This set of keys will always pass the challenge; the link above includes
  # sets that will always challenge or always fail, which is useful for local testing
  config.cf_turnstile_sitekey = ENV.fetch('TURNSTILE_SITE_KEY', nil)
  config.cf_turnstile_secret_key = ENV.fetch('TURNSTILE_SECRET_KEY', nil)

  # How long will a challenge success exempt a session from further challenges?
  # BotChallengePage::BotChallengePageController.bot_challenge_config.session_passed_good_for = 36.hours

  # Exempt async JS facet requests from the challenge. Someone really determined could fake
  # this header, but until we see that behavior, we'll allow it so the facet UI works.
  # We also have an exception for index json so that the mini-bento frontend fetch in Searchworks doesn't get blocked.
  # Also exempt any IPs contained in the CIDR blocks in Settings.turnstile.safelist.
  # Also exempt any user agents in Settings.turnstile.allowed_user_agents (for registered bots/crawlers).
  # Also exempt any logged-in users.
  config.skip_when = lambda do |_config|
    (is_a?(CatalogController) &&
      params[:action].in?(%w[facet index]) && request.format.json? && request.headers['sec-fetch-dest'] == 'empty') ||
      SAFELIST.map { |cidr| IPAddr.new(cidr) }.any? { |range| controller.request.remote_ip.in?(range) }
  end

  # Use a 200 OK status when rendering the challenge so the in-place JS challenge can work
  config.challenge_renderer = lambda {
    render "bot_challenge_page/bot_challenge_page/challenge", status: :ok
  }

  # More configuration is available; see:
  # https://github.com/samvera-labs/bot_challenge_page/blob/main/app/models/bot_challenge_page/config.rb
end
