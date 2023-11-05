require "application_system_test_case"

class UploadQuestionsTest < ApplicationSystemTestCase
  setup do
    @upload_question = upload_questions(:one)
  end

  test "visiting the index" do
    visit upload_questions_url
    assert_selector "h1", text: "Upload Questions"
  end

  test "creating a Upload question" do
    visit upload_questions_url
    click_on "New Upload Question"

    fill_in "Title", with: @upload_question.title
    fill_in "Upload section", with: @upload_question.upload_section_id
    click_on "Create Upload question"

    assert_text "Upload question was successfully created"
    click_on "Back"
  end

  test "updating a Upload question" do
    visit upload_questions_url
    click_on "Edit", match: :first

    fill_in "Title", with: @upload_question.title
    fill_in "Upload section", with: @upload_question.upload_section_id
    click_on "Update Upload question"

    assert_text "Upload question was successfully updated"
    click_on "Back"
  end

  test "destroying a Upload question" do
    visit upload_questions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Upload question was successfully destroyed"
  end
end
