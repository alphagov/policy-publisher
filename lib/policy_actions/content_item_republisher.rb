class ContentItemRepublisher < ContentItemPublisher
 def content_item_payload
    ContentItemPresenter.new(policy, 'minor').exportable_attributes
  end
end
