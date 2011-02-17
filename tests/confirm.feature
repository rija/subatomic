Feature: Subscribe to a hub
As subatomic
I want to confirm subscription to the hub
So that I can get notification of update to the feed


Scenario: hub sends a GET request to the callback handler with wrong details
Given the hub has got the wrong details
When subatomic receives a GET request on callback handler from the hub
Then subatomic callback handler returns Bad Request response header


Scenario: hub sends a GET request to the callback handler with right details
Given the hub has got the right details
When subatomic receives a GET request on callback handler from the hub
Then subatomic callback handler returns Success response  header and hub challenge body


Scenario: an unknown host sends a GET request to the callback handler
Given the hub is unknown
When subatomic receives a GET request on callback handler from the hub
Then subatomic callback handler returns Forbidden response header 

