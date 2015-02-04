User.create(email: 'user@test.example.com').tap do |u|
  u.name = 'Test User'
  u.permissions = ['signin']
  u.save!
end
