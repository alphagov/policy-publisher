Feature: Policy area creation

As a content editor
I need to be able to create and edit policy areas
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy area
  When I create a policy area called "Climate change"
  Then there should be a policy area called "Climate change"
  And a policy area called "Climate change" is published to publishing API

Scenario: Editing a policy area
  Given a published policy area exists called "Global warming"
  When I change the title of policy area "Global warming" to "Climate change"
  Then there should be a policy area called "Climate change"
  And a policy area called "Climate change" is published to publishing API
  Then a policy area called "Climate change" is indexed for search

Scenario: Associating a policy area with an organisation
  Given a policy area exists called "Global warming"
  When I associate the policy area with an organisation
  Then the policy area should be linked to the organisation when published to publishing API

Scenario: Associating a policy area with a person
  Given a policy area exists called "Global warming"
  When I associate the policy area with a person
  Then the policy area should be linked to the person when published to publishing API

@javascript
Scenario: Creating a policy area only associated with one nation
  When I create a policy area called "Policing in Northern Ireland" that only applies to "Northern Ireland"
  Then there should be a policy area called "Policing in Northern Ireland" which only applies to "Northern Ireland"
