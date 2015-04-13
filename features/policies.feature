Feature: Policy creation

As a content editor
I need to be able to create and edit policies
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy
  When I create a policy called "Climate change"
  Then there should be a policy called "Climate change"
  And a policy called "Climate change" is published to publishing API
  And a policy called "Climate change" is indexed for search

Scenario: Editing a policy
  Given a published policy exists called "Global warming"
  When I change the title of policy "Global warming" to "Climate change"
  Then there should be a policy called "Climate change"
  And a policy called "Global warming" is published to publishing API
  And a policy called "Climate change" is indexed for search

Scenario: Associating a policy with an organisation
  Given a policy exists called "Global warming"
  When I associate the policy with an organisation
  Then the policy should be linked to the organisation when published to publishing API

Scenario: Associating a policy with a person
  Given a policy exists called "Global warming"
  When I associate the policy with a person
  Then the policy should be linked to the person when published to publishing API

@javascript
Scenario: Creating a policy only associated with one nation
  When I create a policy called "Policing in Northern Ireland" that only applies to "Northern Ireland"
  Then there should be a policy called "Policing in Northern Ireland" which only applies to "Northern Ireland"
