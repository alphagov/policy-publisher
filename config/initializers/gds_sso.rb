# This initialiser is overwritten when deployed to preview, staging & production.

GDS::SSO.config do |config|
  config.user_model   = 'User'
  config.oauth_id     = ENV['OAUTH_ID']
  config.oauth_secret = ENV['OAUTH_SECRET']
  config.oauth_root_url = Plek.current.find('signon')
end

GDS::SSO.test_user = User.find_or_create_by(email: 'user@test.example.com').tap do |u|
  u.name = 'Test User'
  u.permissions = ['signin']
  u.save!
end
