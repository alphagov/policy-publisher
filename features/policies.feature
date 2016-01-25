Feature: Policy creation

As a content editor
I need to be able to create and edit policies
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy
  When I visit the main browse page
  And I click on "New policy"
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

Scenario: Creating a sub-policy that is part of another
  Given a published policy exists called "Global warming"
  When I visit the main browse page
  And I click on "New sub-policy"
  When I create a sub-policy called "CO2 reduction" that is part of a policy called "Global warming"
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

Scenario: Associating a policy with a working group
  Given a policy exists called "Global warming"
  When I associate the policy with a working group
  Then the policy should be linked to the working group when published to publishing API

Scenario: Preserving links while editing a policy
  Given a policy exists called "Global warming"
  And it is associated with two organisations, two people and two working groups
  When I change the title of policy "Global warming" to "Climate change"
  Then the policy links should remain unchanged

@javascript
Scenario: Creating a policy only associated with one nation
  When I visit the main browse page
  And I click on "New policy"
  When I create a policy called "Policing in Northern Ireland" that only applies to "Northern Ireland"
  Then there should be a policy called "Policing in Northern Ireland" which only applies to "Northern Ireland"
