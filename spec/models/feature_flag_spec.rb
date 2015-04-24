require "rails_helper"

RSpec.describe FeatureFlag do
  it "isn't enabled by default" do
    expect(FeatureFlag.enabled?('undefined-key')).to be(false)
  end

  it "is enabled when set" do
    FeatureFlag.create(key: 'new-key', enabled: true)
    expect(FeatureFlag.enabled?('new-key')).to be(true)
  end

  it "sets the value of a flag" do
    FeatureFlag.create(key: 'set-key')
    FeatureFlag.set('set-key', true)
    expect(FeatureFlag.enabled?('set-key')).to be(true)
    FeatureFlag.set('set-key', false)
    expect(FeatureFlag.enabled?('set-key')).to be(false)
  end
end
