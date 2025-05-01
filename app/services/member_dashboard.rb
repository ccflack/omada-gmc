class MemberDashboard
  attr_accessor :member, :level_type

  UNIT_LOOKUP = {
    continuous_glucose_monitoring: "mg/dL"
  }.freeze

  def initialize(member:, level_type: "continuous_glucose_monitoring")
    raise ArgumentError, "#{level_type} is an invalid level type" unless Level.level_types.include?(level_type)
    raise ArgumentError, "Member not found" if member.nil?

    @member = member
    @level_type = level_type
  end

  def unit
    UNIT_LOOKUP[@level_type.to_sym] || ""
  end

  def data(date_scope:)
    scoped_levels = @member.scoped_levels_for(level_type: @level_type, date_scope: date_scope)
    return {} if scoped_levels.blank?

    average = scoped_levels.average(:value).round(2)
    time_above_threshold_percentage = scoped_levels.above_threshold(180).count / scoped_levels.count.to_f * 100
    time_below_threshold_percentage = scoped_levels.below_threshold(70).count / scoped_levels.count.to_f * 100
    time_in_range_percentage = scoped_levels.in_range(70, 180).count / scoped_levels.count.to_f * 100
    change_from_prior_period_percentage = calculate_change_from_prior_period(scoped_levels: scoped_levels, date_scope: date_scope)

    {
      member: @member,
      level_type: @level_type,
      unit:,
      date_scope:,
      average:,
      time_above_threshold_percentage:,
      time_below_threshold_percentage:,
      time_in_range_percentage:,
      change_from_prior_period_percentage:
    }
  end

  private

  def calculate_change_from_prior_period(scoped_levels:, date_scope:)
    case date_scope
    when "last_7_days"
      prior_period_start = Time.zone.now.beginning_of_day - 13.days
      prior_period_end = Time.zone.now.beginning_of_day - 7.days
    when "month_to_date"
      prior_period_start = Time.zone.now.beginning_of_month - 1.month
      prior_period_end = Time.zone.now.end_of_month - 1.month
    else
      raise ArgumentError, "Invalid date scope"
    end

    prior_period_levels = @member.levels_for(level_type: @level_type).from_date_range(prior_period_start, prior_period_end)

    return 0 if prior_period_levels.empty?

    current_average = scoped_levels.average(:value)
    prior_average = prior_period_levels.average(:value)

    ((current_average - prior_average) / prior_average * 100)
  end
end
