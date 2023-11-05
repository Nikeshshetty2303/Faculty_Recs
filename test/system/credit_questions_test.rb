require "application_system_test_case"

class CreditQuestionsTest < ApplicationSystemTestCase
  setup do
    @credit_question = credit_questions(:one)
  end

  test "visiting the index" do
    visit credit_questions_url
    assert_selector "h1", text: "Credit Questions"
  end

  test "creating a Credit question" do
    visit credit_questions_url
    click_on "New Credit Question"

    fill_in "Credit section", with: @credit_question.credit_section_id
    fill_in "Title", with: @credit_question.title
    click_on "Create Credit question"

    assert_text "Credit question was successfully created"
    click_on "Back"
  end

  test "updating a Credit question" do
    visit credit_questions_url
    click_on "Edit", match: :first

    fill_in "Credit section", with: @credit_question.credit_section_id
    fill_in "Title", with: @credit_question.title
    click_on "Update Credit question"

    assert_text "Credit question was successfully updated"
    click_on "Back"
  end

  test "destroying a Credit question" do
    visit credit_questions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Credit question was successfully destroyed"
  end
end
