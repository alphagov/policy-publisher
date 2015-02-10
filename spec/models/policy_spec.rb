require "rails_helper"

RSpec.describe Policy do
  it "automatically adds a slug on creation" do
    policy = Policy.create!(name: "Climate change")

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    policy.name = "Immigration"
    policy.save!

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy = FactoryGirl.build(:policy, name: '')
    nil_policy = FactoryGirl.build(:policy, name: nil)

    expect(blank_policy).not_to be_valid
    expect(nil_policy).not_to be_valid
  end

  it "enforces unique names" do
    Policy.create!(name: "Climate change")
    duplicate_policy = Policy.new(name: "Climate change")

    expect(duplicate_policy).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = Policy.create!(name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = Policy.new(name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end
end
