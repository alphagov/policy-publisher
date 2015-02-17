Feature: Programmes

As a content editor
I need to be able to create and edit programmes
In order to inform the nation about our government's concrete actions for a topic.

Scenario: Creating a programme
  When I create a programme called "CO2 reduction"
  Then there should be a programme called "CO2 reduction"
  Then a programme called "CO2 reduction" is published "1" times

Scenario: Editing a programme
  Given a programme exists called "CO2 reduction"
  When I change the title of programme "CO2 reduction" to "Carbon credits"
  Then there should be a programme called "Carbon credits"
  Then a programme called "CO2 reduction" is published "2" times

Scenario: Associating a programme with policy areas
  Given a policy area exists called "Climate change"
  And a policy area exists called "UK industry"
  And a programme exists called "Carbon credits"
  When I associate the programme "Carbon credits" with the policy areas "Climate change" and "UK industry"
  Then the programme "Carbon credits" should be associated with the policy areas "Climate change" and "UK industry"
