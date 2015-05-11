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
# Note: This class is dealing with a bunch of stuff that would ideally be
# handled by other parts of the new publishing stack if they existed. e.g. a
# search indexing service would index the content for search; a dependency
# resolver would send out a notification to indicate that the parent policies
# should be republish; another service would generate the content item for the
# email subscription. These will all be added in the fullness of time, at which
# point this class becomes redundant and ContentItemPublisher can be used
# instead.
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
    [ContentItemPublisher, EmailAlertSignupContentItemPublisher, ParentPolicyContentItemRepublisher, SearchIndexer]
  end
end
