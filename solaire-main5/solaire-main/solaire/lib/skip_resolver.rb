class SkipResolver

  attr_accessor :scenario, :status, :case_ids

  def self.resolve scenario, case_ids
    $skip_status ||= {}
    resolver = SkipResolver.new
    resolver.scenario = scenario
    resolver.case_ids = case_ids
    resolver.resolve
  end

  def skip!
    scenario.skip!
  end


  def is_limiting_cases?
    !case_ids.nil?
  end



  def has_more_scenarios_to_run?
    still_to_run_case_ids = (scenario.automated_feature_case_ids & case_ids).length
    still_to_run_case_ids -= $skip_status[scenario.feature.name][:cases_run]
    still_to_run_case_ids > 0
  end

  def has_matching_case_id?
    case_ids.include?(scenario.case_id)
  end

  def resolve
    #initialize status

    if is_limiting_cases?
      if background?
        return skip! if is_background_already_waiting_for_scenario?
        return skip! if !has_more_scenarios_to_run?
      else
        return skip! if !has_matching_case_id?
      end
    end

  end

end
