require "test_helper"

class MemberTest < ActiveSupport::TestCase
  test "should have many levels" do
    member = members(:one)
    assert_not_empty member.levels
  end

  test "full_name should return concatenated first and last name" do
    member = members(:one)
    assert_equal "John Doe", member.full_name
  end

  test "to_s should return full_name" do
    member = members(:one)
    assert_equal member.full_name, member.to_s
  end

  test "levels_for should filter levels by type" do
    member = members(:one)
    levels = member.levels_for(level_type: "continuous_glucose_monitoring")
    assert_not_empty levels
    assert levels.all? { |level| level.level_type == "continuous_glucose_monitoring" }
  end

  test "scoped_levels_for should filter levels by date scope" do
    member = members(:one)
    levels = member.scoped_levels_for(level_type: "continuous_glucose_monitoring", date_scope: "last_7_days")
    assert_not_empty levels
    assert levels.all? { |level| level.level_type == "continuous_glucose_monitoring" }
    assert levels.all? { |level| level.tested_at >= (Time.zone.now.beginning_of_day - 6.days) }
  end
end
