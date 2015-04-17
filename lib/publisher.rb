# Publisher for publishing a policy live onto GOV.UK.
#
# This handles the various actions that must happen to put a policy live on the
# GOV.UK website. This currently means:
#
#   * Pushing a content item to the Publishing API
#   * Adding the policy to the search index
#   * Re-publishing any parent policies to the publshing API to keep the
#     "related" policies of the parents up-to-date.
#
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
