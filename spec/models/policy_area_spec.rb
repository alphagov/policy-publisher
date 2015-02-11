require "rails_helper"

RSpec.describe PolicyArea do
  it "automatically adds a slug on creation" do
    policy_area = PolicyArea.create!(name: "Climate change")

    expect(policy_area.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy_area = FactoryGirl.create(:policy_area, name: "Climate change")

    policy_area.name = "Immigration"
    policy_area.save!

    expect(policy_area.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy_area = FactoryGirl.build(:policy_area, name: '')
    nil_policy_area = FactoryGirl.build(:policy_area, name: nil)

    expect(blank_policy_area).not_to be_valid
    expect(nil_policy_area).not_to be_valid
  end

  it "enforces unique names" do
    PolicyArea.create!(name: "Climate change")
    duplicate_policy_area = PolicyArea.new(name: "Climate change")

    expect(duplicate_policy_area).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = PolicyArea.create!(name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = PolicyArea.new(name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end
end
