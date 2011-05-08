Feature: Subscribe to a hub
As subatomic
I want to subscribe to a hub for a feed I am interested in
So that I can get notification of update to that feed

@happy
Scenario: subatomic send  GET request to the hub with the required information
Given a hub, a feed source, a callback service are configured
And a hub is loaded
When subscribe is called
Then subatomic return Success response header

@failure-mode @hub-error
Scenario: hub is hanging on a GET request with the required information
Given a hub, a feed source, a callback service are configured
When subscribe is called
Then subatomic returns Server Error response header

@failure-mode @wrong-config
Scenario: subatomic send GET request to the hub without the required information
Given GET request to the hub is prepared with incorrect or incomplete input
And a hub is loaded
When subscribe is called
Then subatomic return Bad Request response header


