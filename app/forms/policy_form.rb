class PolicyForm
  ATTRIBUTES = %w[
    id
    name
    description
    sub_policy
    england
    england_policy_url
    northern_ireland
    northern_ireland_policy_url
    scotland
    scotland_policy_url
    wales
    wales_policy_url
  ].freeze

  LINK_ATTRIBUTES = %w[
    lead_organisation_content_ids
    supporting_organisation_content_ids
    people_content_ids
    working_group_content_ids
    parent_policy_ids
  ].freeze

  attr_accessor(*ATTRIBUTES)
  attr_accessor(*LINK_ATTRIBUTES)
  attr_writer :policy

  include ActiveModel::Model

  validates_presence_of :name, :description
  validate :validate_organisations

  def validate_organisations
    lead       = self.lead_organisation_content_ids.to_set
    supporting = self.supporting_organisation_content_ids.to_set

    return if lead.empty? && supporting.empty?

    if lead.intersect?(supporting)
      errors.add(:supporting_organisation_content_ids, "An organisation cannot be tagged as both a lead organisation and a supporting organisation. Please remove the duplicate tags to continue.")
    elsif supporting && lead.empty?
      errors.add(:lead_organisation_content_ids, "There are supporting organisations but no lead organisations. Did you mean to add the organisation as a lead organisation?")
    end
  end

  def self.model_name
    ActiveModel::Name.new(Policy)
  end

  def initialize(attributes = {})
    defaults = {
      england: true,
      scotland: true,
      wales: true,
      northern_ireland: true,
      lead_organisation_content_ids: [],
      supporting_organisation_content_ids: [],
      people_content_ids: [],
      working_group_content_ids: [],
      parent_policy_ids: [],
    }

    super defaults.merge(attributes.to_h)
  end

  def self.from_existing(policy)
    form = new(policy.as_json(only: ATTRIBUTES))
    form.policy = policy
    form.lead_organisation_content_ids = policy.lead_organisation_content_ids
    form.supporting_organisation_content_ids = policy.supporting_organisation_content_ids
    form.people_content_ids = policy.people_content_ids
    form.working_group_content_ids = policy.working_group_content_ids
    form.parent_policy_ids = policy.parent_policy_ids
    form
  end

  def update(attrs)
    attrs.each { |k, v| self.send("#{k}=", v) }

    save if self.valid?
  end

  def save
    return unless valid?

    attributes = as_json(only: ATTRIBUTES)

    policy.set_organisation_priority(@lead_organisation_content_ids, @supporting_organisation_content_ids)
    policy.people_content_ids = @people_content_ids
    policy.working_group_content_ids = @working_group_content_ids
    policy.parent_policy_ids = @parent_policy_ids

    policy.update_attributes(attributes) && publish!
  end

  def error_messages
    errors.full_messages.to_sentence.downcase.sub('lead organisation content ids', 'organisations')
  end

  def policy
    @policy ||= Policy.new
  end

  def persisted?
    policy.id.present?
  end

  def possible_nations
    policy.possible_nations
  end

  def sub_policy?
    policy.sub_policy?
  end

private

  def publish!
    Publisher.new(policy).publish!
    true
  end
end
