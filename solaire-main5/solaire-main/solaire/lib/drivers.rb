Capybara.register_driver :headless do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
end

Capybara.register_driver :chrome do
  Capybara::Selenium::Driver.new({
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w[
          --no-sandbox disable-gpu window-size=1920,1080
          profile.default_content_setting_values.notifications
          --disable-notifications --lang=en --disable-dev-shm-usage
        ]
      }
    )
  })
end
