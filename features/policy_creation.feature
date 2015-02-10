Feature: Policy creation

As a content editor
I need to be able to create and edit policies
In order to inform the nation about our government's intentions for a topic.

Scenario: Creating a policy
  When I create a policy called "Climate change"
  Then there should be a policy called "Climate change"

Scenario: Editing a policy
  Given a policy exists called "Global warming"
  When I change the title of policy "Global warming" to "Climate change"
  Then there should be a policy called "Climate change"
