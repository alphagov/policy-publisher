class PolicyArea < ActiveRecord::Base
  include Publishable
  include ApplicableToNations

  has_and_belongs_to_many :programmes

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
end
