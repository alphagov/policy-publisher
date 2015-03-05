module Publishable
  extend ActiveSupport::Concern

  included do
    validates :content_id, presence: true, uniqueness: true

    before_validation on: :create do |object|
      object.slug = object.name.to_s.parameterize
      object.content_id = SecureRandom.uuid
    end

    after_save :publish_content_item
  end

private
  def publish_content_item
    presenter = ContentItemPresenter.new(self)
    attrs = presenter.exportable_attributes
    publishing_api.put_content_item(presenter.base_path, attrs)
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end
end
