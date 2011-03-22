Given /^a hub, a feed source and a callback service are loaded$/ do
  visit('http://localhost:3000/info')
  page.driver.status_code.should eql(200)
  page.has_content?('http://pommetab.com/feed/atom/').should be_true
  page.has_content?('http://localhost:8080').should be_true
  page.has_content?('http://localhost:3000/callback').should be_true

end

When /^subscribe is called$/ do
  visit('http://localhost:3000/subscribe')
end

Then /^hub returns Success response and subatomic return Success response header$/ do
  page.driver.status_code.should eql(200)
end



When /^subscribe is called and the connection hangs$/ do
  EM::HttpRequest.any_instance.expects(:post).raises(Timeout::Error)
  visit('http://localhost:3000/subscribe')
end


Then /^subatomic returns Server Error response header$/ do
  page.driver.status_code.should eql(500)
end
