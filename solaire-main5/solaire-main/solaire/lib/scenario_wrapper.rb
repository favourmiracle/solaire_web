
class ScenarioWrapper

  attr_accessor :scenario, :testrail_url, :asana_url, :github_url, :case_id, :run_id, :skipped, :run_status

  def initialize scenario
    @scenario = scenario
  end

  # If a method we call is missing, pass the call onto
  # the object we delegate to.
  #def method_missing(m, *args, &block)
  # scenario.send(m, *args, &block)
  #end

  def host
    Capybara.app_host
  end

  def qa_environment
    "#{driver}/#{browser_name}"
  end

  def qa_branch_link
    "https://github.com/"
  end

  def qa_branch
    "master"
  end


  def case_id
    name.split(' - ').first.to_i rescue nil
  end

  def session_id
    Capybara.page.driver.browser.session_id
  end

  def skip!
    @skipped = true
  end

  def skipped?
    !skipped.nil?
  end

  def browser_name
    Capybara.page.driver.browser.browser
  end

  def automated_feature_case_ids
    automated_cases = feature.feature_elements.select{|x| !has_ignored_tag?(x)}
    automated_cases.map(&:name).map{|x| x.split(" - ").first.to_i rescue nil }.compact.reject{|x| x == 0}
  end

  def driver
    Capybara.default_driver
  end

  def exception_details
    exception.backtrace.reverse.join("\n") rescue nil
  end

  def scenario_steps
    test_steps.select{|x| !x.to_s.match(/hook/)}.map{|x| "- #{x}"}
  end

  def status_name
    failed? ? "FAILED" : "PASSED"
  end

  def browser_logs
    if failed?
      @browser_logs ||= browser_console_logs
    end
  end

  # def debug_logs
  #   Cucumber.logger.messages
  # end

  # def screenshot_url
  #   return @screenshot_url if @screenshot_url
  #   if failed?
  #     if S3Client.enabled?
  #       image_path = "screenshots/browserstack-run_#{run_id}-session_#{session_id}-caseid_#{case_id}.png"
  #       Capybara.page.save_screenshot(image_path)
  #       s3_image = S3Client.upload_screenshot(image_path)
  #       @screenshot_url = s3_image
  #     end
  #   end
  # end

  #def background?
  #name == "Background"
  #end


  def run_elapsed time=Time.now.to_i
    Time.at(time - run_status[:start_at]).utc.strftime("%Hhr %Mmin %Ssec")
  end

  def run_time
    run_elapsed run_status[:end_at]
  end

  def test_elapsed time=Time.now.to_i
    Time.at(time - run_status[:scenario_start_at]).utc.strftime("%Hhr %Mmin %Ssec")
  end

  def test_time
    test_elapsed(run_status[:scenario_end_at])
  end

  def has_ignored_tag? obj
    ignored_tags = ENV['SKIP_TAGS'].split(",") rescue []
    (obj.tags.map(&:name) & ignored_tags).any?
  end

  def to_markdown
    result = ["# #{status_name}: #{name}"]
    result << ""
    result << "### HOST:"
    result << "#{host}"
    result << ""
    result << "### ENVIRONMENT:"
    result << "#{driver}: #{browser_name}"
    result << ""
    result << "### TIME ELAPSED:"
    result << "#{test_time}"
    result << ""
    result << "### SCENARIO STEPS:"
    result << scenario_steps.join("\n")
    result << ""
    # if debug_logs.any?
    #   result << "### DEBUG LOGS:"
    #   result << "```"
    #   result += debug_logs
    #   result << "```"
    # end
    if failed?
      result << ""
      result << "### FAILURE:"
      result << "```"
      result << exception
      result << "```"
      result << "```"
      result << exception_details
      result << "```"
      if browser_logs
        result << ""
        result << "### BROWSER CONSOLE LOGS:"
        result << "```"
        result << browser_logs
        result << "```"
      end
      # if screenshot_url
      #   result << ""
      #   result << "### SCREENSHOT"
      #   result << "![Screenshot](#{screenshot_url})"
      # end
    end
    result.join("\n")
  end

end
