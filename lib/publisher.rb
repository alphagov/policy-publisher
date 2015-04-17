# Publisher for publishing polices onto GOV.UK
class Publisher
  attr_reader :policy
  def initialize(policy)
    @policy = policy
  end

  def publish!
    publish_to_publishing_api!
    add_to_search_index!
    republish_parents_to_publishing_api!
  end

private

  def publish_to_publishing_api!
    ContentItemPublisher.new(policy).run!
  end

  def republish_parents_to_publishing_api!
    ParentPolicyContentItemRepublisher.new(policy).run!
  end

  def add_to_search_index!
    SearchIndexer.new(policy).run!
  end
end
