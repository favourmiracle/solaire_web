require "./lib/handlers/local_scenario_handler"
require "./lib/scenario_wrapper"
require "./lib/skip_resolver"

class ScenarioHandler

  attr_accessor :run_id, :testrail_handler, :local_handler, :run_status, :slack_handler, :scenario_wrapper

  def self.setup_handler options
    handler = ScenarioHandler.new
    handler.run_id = options[:run_id]
    handler.local_handler = LocalScenarioHandler.new(options)
    handler.run_status = {
      skipped: 0,
      passed: 0,
      failed: 0,
      start_at: Time.now.to_i,
      features: {}
    }
    handler
  end

  def before_scenario scenario
    @scenario_wrapper = ScenarioWrapper.new(scenario)
    scenario_wrapper.run_id = run_id
    scenario_wrapper.run_status = run_status
    run_status[:scenario_start_at] = Time.now.to_i
    case_ids = local_handler ? local_handler.case_ids : true
    SkipResolver.resolve(scenario_wrapper, case_ids)
    if scenario_wrapper.skipped?
      run_status[:skipped] += 1
      return false
    end
    if local_handler
      local_handler.before_scenario(scenario_wrapper)
    end
  end

  def after_scenario scenario
    scenario_wrapper.scenario = scenario
    run_status[:last_scenario] = scenario_wrapper
    run_status[:scenario_end_at] = Time.now.to_i
    return true if scenario_wrapper.skipped?
  end

  #def after_all
  # run_status[:end_at] = Time.now.to_i
  # local_handler.after_all(run_status) if local_handler
  #end

end
