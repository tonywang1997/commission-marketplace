require "application_system_test_case"

class HasTagsTest < ApplicationSystemTestCase
  setup do
    @has_tag = has_tags(:one)
  end

  test "visiting the index" do
    visit has_tags_url
    assert_selector "h1", text: "Has Tags"
  end

  test "creating a Has tag" do
    visit has_tags_url
    click_on "New Has Tag"

    fill_in "Artist", with: @has_tag.artist_id
    fill_in "Tag", with: @has_tag.tag_id
    click_on "Create Has tag"

    assert_text "Has tag was successfully created"
    click_on "Back"
  end

  test "updating a Has tag" do
    visit has_tags_url
    click_on "Edit", match: :first

    fill_in "Artist", with: @has_tag.artist_id
    fill_in "Tag", with: @has_tag.tag_id
    click_on "Update Has tag"

    assert_text "Has tag was successfully updated"
    click_on "Back"
  end

  test "destroying a Has tag" do
    visit has_tags_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Has tag was successfully destroyed"
  end
end
