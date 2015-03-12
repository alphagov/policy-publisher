class PolicyArea < ActiveRecord::Base
  include Publishable

  has_and_belongs_to_many :programmes

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true

  serialize :organisation_content_ids, Array
end
