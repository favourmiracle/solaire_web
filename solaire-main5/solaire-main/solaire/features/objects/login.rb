#check
class LoginPage
  include PageObject
  include Capybara::DSL

  def self.login
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to "https://player360-dev.solaireresort.com"
  driver.manage.window.maximize
  sleep(3)
  wait = Selenium::WebDriver::Wait.new(timeout: 20)

  wait until (element = driver.find_element(:id, "username"))
  element.send_keys("alyssasantos")
  sleep(2)
  wait until (element = driver.find_element(:id, "password"))
  element.send_keys("Password01")
  sleep(2)
  wait until (element = driver.find_element(:xpath, "//span[contains(text(),'Login')]"))
  element.click if element.displayed?
  sleep(30)
  driver.quit
  end
end
