# Turn on temporary feature-flag for future-policies feature during selected tests
# As it's stored in the database it will be wiped after every test anyway
Before("@future-policies") do
  FeatureFlag.create(key: 'future_policies', enabled: true)
end
