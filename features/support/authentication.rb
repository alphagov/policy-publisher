Before do
  FactoryBot.create(:user)
end

After do
  Capybara.reset_session!
end
