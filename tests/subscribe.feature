Feature: Subscribe to a hub
As subatomic
I want to subscribe to a hub for a feed I am interested in
So that I can get notification of update to that feed

@happy
Scenario: subatomic send  GET request to the hub with the required information
Given a hub, a feed source, a callback service are configured
And a hub is loaded
When subscribe is called
Then hub returns Success response and subatomic return Success response header

@failure-mode @timeout
Scenario: hub is hanging on a GET request with the required information
Given a hub, a feed source, a callback service are configured
When the connection to the hub hangs
Then subatomic returns Server Error response header

@failure-mode
Scenario: subatomic send GET request to the hub without the required information
Given GET request to the hub is prepared without all required information
When GET request is sent to the hub
Then hub returns Bad Request response and subatomic return Bad Request response header


