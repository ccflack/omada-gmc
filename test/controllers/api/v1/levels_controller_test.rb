require "test_helper"

class Api::V1::LevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:one)
    @other_member = members(:two)
    @level1 = levels(:near_one)   # tested_at: 1 day ago, member_id: 1
    @level2 = levels(:near_two)   # tested_at: 2 days ago, member_id: 1
    @level3 = levels(:near_three) # tested_at: 3 days ago, member_id: 1
    @other_member_level = levels(:other_member_level) # tested_at: 1 day ago, member_id: 2
  end

  test "should return levels within the specified date range for a specific member" do
    get api_v1_levels_url, params: { member_id: @member.id, start_date: 3.days.ago.to_date, end_date: 1.day.ago.to_date }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal 3, response_data.size
  end

  test "should return an empty array when no levels match the date range for a specific member" do
    get api_v1_levels_url, params: { member_id: @member.id, start_date: 12.days.ago.to_date, end_date: 11.days.ago.to_date }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_empty response_data
  end

  test "should not return levels for other members" do
    get api_v1_levels_url, params: { member_id: @member.id, start_date: 1.day.ago.to_date, end_date: 1.day.ago.to_date }
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_not_includes response_data.map { |level| level["id"] }, @other_member_level.id
  end

  test "should return 400 Bad Request when parameters are missing" do
    get api_v1_levels_url, params: { start_date: 3.days.ago.to_date }
    assert_response :bad_request
  end
end
