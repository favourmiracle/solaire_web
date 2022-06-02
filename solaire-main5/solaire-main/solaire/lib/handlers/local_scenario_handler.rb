class LocalScenarioHandler
  attr_accessor :run_id, :driver_name, :feature_runs

  def initialize options
    @run_id = options[:run_id]
    @driver_name = options[:driver_name]
  end

  def before_scenario scenario
  end

  def case_ids
    ENV['CASE_IDS'].split(",").map(&:to_i) rescue nil
  end

  # def after_scenario scenario
  #  if scenario.failed?
  #    puts "ERROR: Something went wrong."
  #else
  #   puts "INFO: This test case ran smoothly. No screenshot needed!"
  # end
  #end

end
