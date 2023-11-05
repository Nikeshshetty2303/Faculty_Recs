require "application_system_test_case"

class FileUploadsTest < ApplicationSystemTestCase
  setup do
    @file_upload = file_uploads(:one)
  end

  test "visiting the index" do
    visit file_uploads_url
    assert_selector "h1", text: "File Uploads"
  end

  test "creating a File upload" do
    visit file_uploads_url
    click_on "New File Upload"

    fill_in "File", with: @file_upload.file
    click_on "Create File upload"

    assert_text "File upload was successfully created"
    click_on "Back"
  end

  test "updating a File upload" do
    visit file_uploads_url
    click_on "Edit", match: :first

    fill_in "File", with: @file_upload.file
    click_on "Update File upload"

    assert_text "File upload was successfully updated"
    click_on "Back"
  end

  test "destroying a File upload" do
    visit file_uploads_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "File upload was successfully destroyed"
  end
end
