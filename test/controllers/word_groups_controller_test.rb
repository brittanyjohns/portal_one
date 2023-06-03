require "test_helper"

class WordGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word_group = word_groups(:one)
  end

  test "should get index" do
    get word_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_word_group_url
    assert_response :success
  end

  test "should create word_group" do
    assert_difference("WordGroup.count") do
      post word_groups_url, params: { word_group: { group_id: @word_group.group_id, user_id: @word_group.user_id, word_id: @word_group.word_id } }
    end

    assert_redirected_to word_group_url(WordGroup.last)
  end

  test "should show word_group" do
    get word_group_url(@word_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_word_group_url(@word_group)
    assert_response :success
  end

  test "should update word_group" do
    patch word_group_url(@word_group), params: { word_group: { group_id: @word_group.group_id, word_id: @word_group.word_id } }
    assert_redirected_to word_group_url(@word_group)
  end

  test "should destroy word_group" do
    assert_difference("WordGroup.count", -1) do
      delete word_group_url(@word_group)
    end

    assert_redirected_to word_groups_url
  end
end
