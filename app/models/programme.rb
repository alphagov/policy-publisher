class Programme < ActiveRecord::Base
  include Publishable

  has_and_belongs_to_many :policy_areas

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation on: :create do |programme|
    programme.slug = programme.name.to_s.parameterize
  end

  def to_s
    name
  end
end
