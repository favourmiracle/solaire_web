require 'capybara'
require 'page-object'
require './lib/drivers'
require 'capybara/rspec'
require 'capybara/cucumber'
require 'selenium/webdriver'
# require './lib/fast-selenium'
require 'page-object/page_factory'
require './lib/handlers/scenario_handler'
require 'C:\Users\sydne\Downloads\solaire-main5\solaire-main\solaire\features\support\screen_factory.rb'

include PageObject::PageFactory

app_domain = ENV['APP_HOST'] ? ENV['APP_HOST'] : "https://https://player360-dev.solaireresort.com"
Capybara.app_host = "#{app_domain}"
$host = Capybara.app_host
puts $host

Capybara.default_driver = (ENV['WEB_DRIVER'] || 'chrome').to_sym

scenario_handler = ScenarioHandler.setup_handler({
  run_id: ENV['TESTRUN_ID'], driver_name: Capybara.default_driver
})



#After do |scenario|
# if !scenario_handler.after_scenario(scenario) && ENV['FAILFAST'] == "true"
#   Cucumber.wants_to_quit=true
# end
# clear_local_storage
#end

at_exit do
  #  scenario_handler.after_all
end

def browser_console_logs
  current_url = Capybara.current_url.to_s
  unless (ENV['WEB_DRIVER']).nil? or %w(browserstack headless).include?(ENV['WEB_DRIVER'])
    logs = page.driver.browser.manage.logs.get(:browser).map {|line| [line.level, line.message]}
    logs.reject! { |line| ['WARNING', 'INFO'].include?(line.first) }
    $browser_logs = ( "Current URL: " + current_url + "\n") + logs.join("\n")
  else
    $browser_logs = ( "Current URL: " + current_url + "\n")
  end
end

def clear_local_storage
  begin
    puts "LOG: Clearing local storage"
    Capybara.execute_script 'localStorage.clear()'
  rescue Selenium::WebDriver::Error::WebDriverError => e
    puts "LOG: Rescuing local storage exception."
  end
end
