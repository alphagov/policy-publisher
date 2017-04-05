# This initialiser is overwritten when deployed to integration, staging & production.

GDS::SSO.config do |config|
  config.user_model   = 'User'
  config.oauth_id     = ENV['OAUTH_ID'] || "abcdefg"
  config.oauth_secret = ENV['OAUTH_SECRET'] || "secret"
  config.oauth_root_url = Plek.current.find('signon')
end
