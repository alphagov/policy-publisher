module PolicyPublisher
  # Signifies whether policies should be published live to GOV.UK or not.
  def self.future_policies_enabled?
    !!ENV['ENABLE_FUTURE_POLICIES']
  end
end
