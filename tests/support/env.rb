require 'capybara/cucumber'
require 'mocha'
require 'em-http'

require 'sync'

Capybara.app = Sync
Capybara.default_driver = :culerity


