require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  setup do
    @word = words(:one)
  end

  test "visiting the index" do
    visit words_url
    assert_selector "h1", text: "Words"
  end

  test "should create word" do
    visit words_url
    click_on "New word"

    fill_in "Category", with: @word.category_id
    check "Favorite" if @word.favorite
    fill_in "Group", with: @word.group_id
    fill_in "Name", with: @word.name
    click_on "Create Word"

    assert_text "Word was successfully created"
    click_on "Back"
  end

  test "should update Word" do
    visit word_url(@word)
    click_on "Edit this word", match: :first

    fill_in "Category", with: @word.category_id
    check "Favorite" if @word.favorite
    fill_in "Group", with: @word.group_id
    fill_in "Name", with: @word.name
    click_on "Update Word"

    assert_text "Word was successfully updated"
    click_on "Back"
  end

  test "should destroy Word" do
    visit word_url(@word)
    click_on "Destroy this word", match: :first

    assert_text "Word was successfully destroyed"
  end
end
