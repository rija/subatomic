require 'rest_client'
@response = nil

Given /^a hub, a feed source, a callback service are configured$/ do
  visit('http://localhost:3000/info')
  page.driver.status_code.should eql(200)
  page.has_content?('http://www.pommetab.com/feed/atom/').should be_true
  page.has_content?('http://localhost:8080').should be_true
  page.has_content?('http://localhost:3000/callback').should be_true

end

And /^a hub is loaded$/ do
  system "python2.5 ~/Projects/pshb/google_appengine/dev_appserver.py ~/Projects/pshb/pubsubhubbub/hub/ &"
  sleep 2
  visit('http://localhost:8080')
  page.driver.status_code.should eql(200)
end

When /^subscribe is called$/ do
  @response = RestClient.get 'http://localhost:3000/subscribe'
end

Then /^hub returns Success response and subatomic return Success response header$/ do
  #page.driver.status_code.should eql(200)
  @response.code.should eql(200)
end



When /^the connection to the hub hangs$/ do
  visit('http://localhost:3000/subscribe')
end


Then /^subatomic returns Server Error response header$/ do
  page.driver.status_code.should eql(500)
end

After do
  hub_process =`ps -ef | grep python2.5 | grep -v grep | cut -f6 -d' '`
  if hub_process =~ /\d+/
    system "kill #{hub_process}"
  end
end