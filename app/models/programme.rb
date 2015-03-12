class Programme < ActiveRecord::Base
  include Publishable
  include ApplicableToNations

  has_and_belongs_to_many :policy_areas

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true

  def to_s
    name
  end
end
