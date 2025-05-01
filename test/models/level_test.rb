require "test_helper"

class LevelTest < ActiveSupport::TestCase
  test "should belong to a member" do
    level = levels(:near_one)
    assert_not_nil level.member
  end

  test "should validate inclusion of level_type in allowed types" do
    level = Level.new(level_type: "invalid_type", value: 100, tested_at: Time.now, tz_offset: "-07:00", unit: "mg/dL")
    assert_not level.valid?
    assert_includes level.errors[:level_type], "is not included in the list"
  end

  test "to_s should return value and unit" do
    level = levels(:near_one)
    assert_equal "#{level.value} #{level.unit}", level.to_s
  end
end
