require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'database_cleaner'
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
end
config.before(:each) do
   DatabaseCleaner.strategy = :deletion
end

config.before(:each, :js => true) do
	DatabaseCleaner.strategy = :deletion
end
config.before(:each) do
    DatabaseCleaner.start
 end
config.after(:each) do
   	DatabaseCleaner.clean

end
end