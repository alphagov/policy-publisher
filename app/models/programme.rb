class Programme < ActiveRecord::Base
  include Publishable
  include ApplicableToNations

  has_and_belongs_to_many :policy_areas

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true

  after_save :republish_parents!

  def to_s
    name
  end

  def republish_parents!
    policy_areas.each(&:republish!)
  end
end
