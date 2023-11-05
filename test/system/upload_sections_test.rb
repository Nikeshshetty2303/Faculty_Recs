require "application_system_test_case"

class UploadSectionsTest < ApplicationSystemTestCase
  setup do
    @upload_section = upload_sections(:one)
  end

  test "visiting the index" do
    visit upload_sections_url
    assert_selector "h1", text: "Upload Sections"
  end

  test "creating a Upload section" do
    visit upload_sections_url
    click_on "New Upload Section"

    fill_in "Title", with: @upload_section.title
    click_on "Create Upload section"

    assert_text "Upload section was successfully created"
    click_on "Back"
  end

  test "updating a Upload section" do
    visit upload_sections_url
    click_on "Edit", match: :first

    fill_in "Title", with: @upload_section.title
    click_on "Update Upload section"

    assert_text "Upload section was successfully updated"
    click_on "Back"
  end

  test "destroying a Upload section" do
    visit upload_sections_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Upload section was successfully destroyed"
  end
end
