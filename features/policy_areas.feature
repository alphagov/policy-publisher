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
  And a policy area called "Global warming" is published to publishing API
