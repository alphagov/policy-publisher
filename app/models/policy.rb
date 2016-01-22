class Policy < ActiveRecord::Base
  validates :content_id, presence: true, uniqueness: true
  validates :name, :slug, presence: true, uniqueness: true
  validates :description, presence: true
  validates :email_alert_signup_content_id, presence: true, uniqueness: true

  validate :applicable_to_at_least_one_nation
  validate :alternative_urls_are_valid

  has_many :policy_relations
  has_many :related_policies, class_name: 'Policy', through: :policy_relations, source: :related_policy

  has_many :inverse_policy_relations, class_name: 'PolicyRelation', foreign_key: 'related_policy_id'
  has_many :parent_policies, through: :inverse_policy_relations, source: :policy

  before_validation on: :create do |object|
    object.slug = object.name.to_s.parameterize
    object.content_id = SecureRandom.uuid
    object.email_alert_signup_content_id = SecureRandom.uuid
  end

  scope :areas, -> { joins("LEFT OUTER JOIN policy_relations
                            ON policies.id = policy_relations.related_policy_id
                            WHERE policy_relations.related_policy_id IS NULL") }

  # Virtual attribute used to identify a new record as a sub-policy
  attr_writer :sub_policy
  def sub_policy
    @sub_policy || parent_policies.any?
  end
  alias_method :sub_policy?, :sub_policy

  attr_accessor :organisation_content_ids
  attr_accessor :lead_organisation_content_ids
  attr_accessor :people_content_ids
  attr_accessor :working_group_content_ids

  after_initialize do
    self.organisation_content_ids ||= []
    self.lead_organisation_content_ids ||= []
    self.people_content_ids ||= []
    self.working_group_content_ids ||= []
  end

  def base_path
    "/government/policies/#{slug}"
  end

  def possible_nations
    [
      :england,
      :northern_ireland,
      :scotland,
      :wales,
    ]
  end

  def applicable_nations
    possible_nations.select { |n| self.send(n) == true }
  end

  def inapplicable_nations
    possible_nations - applicable_nations
  end

  def organisations(fetcher = ContentItemFetcher.new)
    @fetched_organisations ||= organisation_content_ids.map { |content_id| fetcher.find_organisation(content_id) }.compact
  end

  def people(fetcher = ContentItemFetcher.new)
    @fetched_people ||= people_content_ids.map { |content_id| fetcher.find_person(content_id) }.compact
  end

  def working_groups(fetcher = ContentItemFetcher.new)
    @fetched_working_groups ||= working_group_content_ids.map { |content_id| fetcher.find_working_group(content_id) }.compact
  end

  # Fetch links from the publisher-api
  def fetch_links!
    return if content_id.blank?

    links = Services.publishing_api.get_links(content_id)["links"]

    self.lead_organisation_content_ids = links["lead_organisations"] || []
    self.organisation_content_ids = links["organisations"] || []
    self.people_content_ids = links["people"] || []
    self.working_group_content_ids = links["working_groups"] || []
  end

  def set_organisation_priority(lead_organisation_content_ids, supporting_organisation_content_ids)
    self.lead_organisation_content_ids = lead_organisation_content_ids
    self.organisation_content_ids = lead_organisation_content_ids + supporting_organisation_content_ids
  end

  def supporting_organisation_content_ids
    organisation_content_ids - lead_organisation_content_ids
  end

private
  def applicable_to_at_least_one_nation
    if applicable_nations.empty?
      errors.add(:applicability, "must have at least one nation")
    end
  end

  def alternative_urls_are_valid
    alt_policy_urls = inapplicable_nations.select { |nation|
      self.send(:"#{nation}_policy_url").present?
    }

    nations_with_bad_urls = alt_policy_urls.reject { |nation|
      self.send(:"#{nation}_policy_url") =~ /\A#{URI::regexp(['http', 'https'])}\z/
    }

    nations_with_bad_urls.each do |nation|
      errors.add(nation, "must have a valid alternative policy URL")
    end
  end
end
