require 'rails_helper'

RSpec.describe DataForSelectHelper, type: :helper do
  def stub_publishing_api(status:, body:)
    stub_request(:get, %r{#{Plek.find('publishing-api')}/v2/linkables}).
      to_return(status: status, body: body)
  end

  def build_response_body(titles: [])
    titles.map! do |title|
      { 'content_id' => SecureRandom.uuid, 'title' => title }
    end

    titles.to_json
  end

  describe '#prioritise_data_container' do
    let(:youth_content_id)  { "47336035-23b3-4d3c-b167-195e820240b2" }
    let(:animal_content_id) { "06d8614b-ceea-46b2-8f04-f8d73d8eeef2" }

    let(:unprioritised_container) do
      [
        ["Ancient", "af539468-c8df-487c-987f-f737dce181eb"],
        ["Animal", animal_content_id],
        ["Water", "cef82b42-a8a0-45c9-b204-259ec464c1c3"],
        ["Youth", youth_content_id],
      ]
    end

    context 'when has selected items' do
      let(:selected) { [youth_content_id, animal_content_id] }

      it 'sorts the selected items and moves them to the top of the list' do
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

    context 'when nothing is selected' do
      let(:selected) { [] }

      it 'returns the unmodified input list' do
        expect(
          helper.prioritise_data_container(unprioritised_container, selected)
        ).to eq(unprioritised_container)
      end
    end
  end

  describe '#organisations_data_container' do
    it 'returns a list of organisations sorted by title' do
      titles = %w(Taxes Animal Education)
      stub_publishing_api(status: 200, body: build_response_body(titles: titles))

      expect(helper.organisations_data_container.map(&:first)).to eql %w(Animal Education Taxes)
    end
  end

  describe '#people_data_container' do
    it 'returns a list of people sorted by title' do
      titles = %w(Zoe Ana Henry)
      stub_publishing_api(status: 200, body: build_response_body(titles: titles))

      expect(helper.people_data_container.map(&:first)).to eql %w(Ana Henry Zoe)
    end
  end

  describe '#working_groups_data_container' do
    it 'returns a list of working groups sorted by title' do
      titles = %w(Z B C)
      stub_publishing_api(status: 200, body: build_response_body(titles: titles))

      expect(helper.people_data_container.map(&:first)).to eql %w(B C Z)
    end
  end

  describe '#policies_areas_data_container' do
    it 'returns a list of policy areas with name and id' do
      policy = create :policy
      expect(helper.policies_areas_data_container).to eql([[policy.name, policy.id]])
    end
  end
end
