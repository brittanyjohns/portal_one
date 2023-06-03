require "application_system_test_case"

class WordGroupsTest < ApplicationSystemTestCase
  setup do
    @word_group = word_groups(:one)
  end

  test "visiting the index" do
    visit word_groups_url
    assert_selector "h1", text: "Word groups"
  end

  test "should create word group" do
    visit word_groups_url
    click_on "New word group"

    fill_in "Group", with: @word_group.group_id
    fill_in "Word", with: @word_group.word_id
    click_on "Create Word group"

    assert_text "Word group was successfully created"
    click_on "Back"
  end

  test "should update Word group" do
    visit word_group_url(@word_group)
    click_on "Edit this word group", match: :first

    fill_in "Group", with: @word_group.group_id
    fill_in "Word", with: @word_group.word_id
    click_on "Update Word group"

    assert_text "Word group was successfully updated"
    click_on "Back"
  end

  test "should destroy Word group" do
    visit word_group_url(@word_group)
    click_on "Destroy this word group", match: :first

    assert_text "Word group was successfully destroyed"
  end
end
