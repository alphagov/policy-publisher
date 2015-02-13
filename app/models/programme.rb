class Programme < ActiveRecord::Base
  include Publishable

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation on: :create do |programme|
    programme.slug = programme.name.to_s.parameterize
  end
end
