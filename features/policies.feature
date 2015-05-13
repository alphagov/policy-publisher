Feature: Policy creation

As a content editor
I need to be able to create and edit policies
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy
  When I create a policy called "Climate change"
  Then there should be a policy called "Climate change"
  And a policy called "Climate change" is published to publishing API
  And an email alert signup page for a policy called "Climate change" is published to publishing API
  And a policy called "Climate change" is indexed for search

Scenario: Editing a policy
  Given a published policy exists called "Global warming"
  When I change the title of policy "Global warming" to "Climate change"
  Then there should be a policy called "Climate change"
  And a policy called "Climate change" is published to publishing API
  And an email alert signup page for a policy called "Climate change" is published to publishing API
  And a policy called "Climate change" is indexed for search

Scenario: Creating a policy programme that is part of another
  Given a published policy exists called "Global warming"
  When I create a policy programme called "CO2 reduction" that is part of a policy called "Global warming"
  Then there should be a policy called "CO2 reduction" that is part of a policy called "Global warming"
  And a policy called "CO2 reduction" is published to publishing API
  And a policy called "CO2 reduction" is indexed for search
  And a policy called "Global warming" is republished to publishing API

Scenario: Associating a policy with an organisation
  Given a policy exists called "Global warming"
  When I associate the policy with an organisation
  Then the policy should be linked to the organisation when published to publishing API

Scenario: Associating a policy with a person
  Given a policy exists called "Global warming"
  When I associate the policy with a person
  Then the policy should be linked to the person when published to publishing API

@javascript
Scenario: Re-ordering tagged organisations
  Given a policy exists called "Global warming"
  And the policy is associated with the organisations "Organisation 1" and "Organisation 2"
  When I set the tagged organisations to "Organisation 2" and "Organisation 1"
  Then the policy organisations should appear in the order "Organisation 2" and "Organisation 1"

@javascript
Scenario: Re-ordering tagged people
  Given a policy exists called "Global warming"
  And the policy is associated with the people "A Person" and "Another Person"
  When I set the tagged people to "Another Person" and "A Person"
  Then the policy people should appear in the order "Another Person" and "A Person"


@javascript
Scenario: Creating a policy only associated with one nation
  When I create a policy called "Policing in Northern Ireland" that only applies to "Northern Ireland"
  Then there should be a policy called "Policing in Northern Ireland" which only applies to "Northern Ireland"
