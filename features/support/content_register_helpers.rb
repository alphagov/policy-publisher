require 'gds_api/test_helpers/content_register'

Before do
  mock_content_register
end

module ContentRegisterHelpers
  include GdsApi::TestHelpers::ContentRegister

  def mock_content_register
    stub_content_register_entries("organisation", [organisation_1, organisation_2])
    stub_content_register_entries("person", [person_1, person_2])
  end

  def organisation_1
    @organisation_1 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 1",
      "base_path" => "/government/organisations/organisation-1",
    }
  end

  def organisation_2
    @organisation_2 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 2",
      "base_path" => "/government/organisations/organisation-2",
    }
  end

  def person_1
    @person_1 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "person",
      "title" => "A Person",
      "base_path" => "/government/organisations/a-person",
    }
  end


  def person_2
    @person_2 ||= {
      "content_id" => SecureRandom.uuid,
      "format" => "person",
      "title" => "Another Person",
      "base_path" => "/government/organisations/another-person",
    }
  end
end

World(ContentRegisterHelpers)
