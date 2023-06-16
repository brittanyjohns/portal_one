require "application_system_test_case"

class GalleriesTest < ApplicationSystemTestCase
  setup do
    @gallery = galleries(:one)
  end

  test "visiting the index" do
    visit galleries_url
    assert_selector "h1", text: "Galleries"
  end

  test "should create gallery" do
    visit galleries_url
    click_on "New gallery"

    fill_in "Image prompt", with: @gallery.image_prompt
    fill_in "Name", with: @gallery.name
    check "Send request on save" if @gallery.send_request_on_save
    fill_in "State", with: @gallery.state
    fill_in "User", with: @gallery.user_id
    click_on "Create Gallery"

    assert_text "Gallery was successfully created"
    click_on "Back"
  end

  test "should update Gallery" do
    visit gallery_url(@gallery)
    click_on "Edit this gallery", match: :first

    fill_in "Image prompt", with: @gallery.image_prompt
    fill_in "Name", with: @gallery.name
    check "Send request on save" if @gallery.send_request_on_save
    fill_in "State", with: @gallery.state
    fill_in "User", with: @gallery.user_id
    click_on "Update Gallery"

    assert_text "Gallery was successfully updated"
    click_on "Back"
  end

  test "should destroy Gallery" do
    visit gallery_url(@gallery)
    click_on "Destroy this gallery", match: :first

    assert_text "Gallery was successfully destroyed"
  end
end
