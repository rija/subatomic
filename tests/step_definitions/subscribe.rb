require 'rest_client'
@response = nil

Given /^a hub, a feed source, a callback service are configured$/ do
  system "thin -r ~/Projects/subatomic/prototype/sync.rb  start -R ~/Projects/subatomic/prototype/sync.ru -DV &"
  sleep 2
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
  begin
    @response = RestClient.get 'http://localhost:3000/subscribe'
  rescue Exception => e
    @response = e
  end
end

Then /^subatomic return Success response header$/ do
  @response.code.should eql(200)
end


Then /^subatomic returns Server Error response header$/ do
  @response.kind_of?(RestClient::InternalServerError).should be_true
end


Given /^GET request to the hub is prepared with incorrect or incomplete input$/ do
  
  configdir = File.dirname(__FILE__) + "/../../prototype"
  system "mv #{configdir}/config.yml #{configdir}/orig.config.yml"
  system "cp #{configdir}/bad.config.yml #{configdir}/config.yml"
  system "thin -r ~/Projects/subatomic/prototype/sync.rb  start -R ~/Projects/subatomic/prototype/sync.ru -DV &"
  sleep 2
  visit('http://localhost:3000/info')
  page.driver.status_code.should eql(200)
  page.has_content?('http://www.pommetab.com/feed/atom/').should be_false
  page.has_content?('http://localhost:8080').should be_true
  page.has_content?('http://localhost:3000/callback').should be_false
  
end

Then /^subatomic return Bad Request response header$/ do
  @response.kind_of?(RestClient::BadRequest).should be_true
end

After do
  configdir = File.dirname(__FILE__) + "/../../prototype"
  if Dir.entries(configdir).detect {|f| f.match /orig.config.yml$/}
    system "mv #{configdir}/orig.config.yml #{configdir}/config.yml"
  end
end

After do
  hub_process =`ps -o pid -o command | grep python2.5  | grep pubsubhubbub | grep -v grep | cut -f2 -d' '`
  if hub_process =~ /\d+/
    system "kill #{hub_process}"
  end
end


After do
  sync_process =`ps -o pid -o command | grep thin | grep "sync.rb" | grep -v grep | cut -f2 -d' '`
  if sync_process =~ /\d+/
    system "kill #{sync_process}"
  end
end