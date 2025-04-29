require "application_system_test_case"

class LevelsTest < ApplicationSystemTestCase
  setup do
    @level = levels(:one)
  end

  test "visiting the index" do
    visit levels_url
    assert_selector "h1", text: "Levels"
  end

  test "should create level" do
    visit levels_url
    click_on "New level"

    click_on "Create Level"

    assert_text "Level was successfully created"
    click_on "Back"
  end

  test "should update Level" do
    visit level_url(@level)
    click_on "Edit this level", match: :first

    click_on "Update Level"

    assert_text "Level was successfully updated"
    click_on "Back"
  end

  test "should destroy Level" do
    visit level_url(@level)
    accept_confirm { click_on "Destroy this level", match: :first }

    assert_text "Level was successfully destroyed"
  end
end
