Feature: Policy area creation

As a content editor
I need to be able to create and edit policy areas
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy area
  When I create a policy area called "Climate change"
  Then there should be a policy area called "Climate change"

Scenario: Editing a policy area
  Given a policy area exists called "Global warming"
  When I change the title of policy area "Global warming" to "Climate change"
  Then there should be a policy area called "Climate change"
