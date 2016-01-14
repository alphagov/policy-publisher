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
    organisation_content_ids
    people_content_ids
    working_group_content_ids
    parent_policy_ids
  ]

  attr_accessor(*ATTRIBUTES)
  attr_accessor :policy

  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(Policy)
  end

  def self.new_with_defaults
    new(
      england: true,
      scotland: true,
      wales: true,
      northern_ireland: true,
      organisation_content_ids: [],
      people_content_ids: [],
      working_group_content_ids: [],
      parent_policy_ids: [],
    )
  end

  def self.from_form(policy_params)
    new(policy_params)
  end

  def self.from_existing(policy)
    form = new(policy.as_json(only: ATTRIBUTES))
    form.policy = policy
    form
  end

  def update(attrs)
    attrs.each { |k, v| self.send("#{k}=", v) }
    save
  end

  def save
    attributes = as_json(only: ATTRIBUTES)
    policy.update_attributes(attributes) && publish!
  end

  def error_message
    policy.errors.full_messages.to_sentence.downcase
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
    sub_policy
  end

  def organisation_content_ids
    policy.organisation_content_ids
  end

  def people_content_ids
    policy.people_content_ids
  end

  def working_group_content_ids
    policy.working_group_content_ids
  end

private
  def publish!
    Publisher.new(policy).publish!
    true
  end
end
