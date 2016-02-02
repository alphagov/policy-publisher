require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:youth_content_id)  { "47336035-23b3-4d3c-b167-195e820240b2" }
  let(:animal_content_id) { "06d8614b-ceea-46b2-8f04-f8d73d8eeef2" }

  let(:selected) { [youth_content_id, animal_content_id] }

  let(:unprioritised_container) do
    [
      ["Ancient", "af539468-c8df-487c-987f-f737dce181eb"],
      ["Animal", animal_content_id],
      ["Water", "cef82b42-a8a0-45c9-b204-259ec464c1c3"],
      ["Youth", youth_content_id],
    ]
  end

  describe '#prioritise_data_container' do
    it 'sorts the data in alphabetical order' do
      expected = [
        ["Animal", animal_content_id],
        ["Youth", youth_content_id],
        ["Ancient", "af539468-c8df-487c-987f-f737dce181eb"],
        ["Water", "cef82b42-a8a0-45c9-b204-259ec464c1c3"],
      ]

      expect(
        helper.prioritise_data_container(unprioritised_container, selected)
      ).to eq(expected)
    end
  end
end
