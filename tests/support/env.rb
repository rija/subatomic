require 'capybara/cucumber'

require 'sync'

Capybara.app = Sync
Capybara.default_driver = :culerity


module Syncapp
def app; Capybara.app; end
end
World(Syncapp)