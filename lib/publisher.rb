# Publisher for publishing a policy live onto GOV.UK
class Publisher
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def publish!
    publish_actions.each { |klass| klass.new(policy).run! }
  end

private

  def publish_actions
    [ContentItemPublisher, ParentPolicyContentItemRepublisher, SearchIndexer]
  end
end
