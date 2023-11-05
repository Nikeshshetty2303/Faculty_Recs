require "application_system_test_case"

class CreditAnswersTest < ApplicationSystemTestCase
  setup do
    @credit_answer = credit_answers(:one)
  end

  test "visiting the index" do
    visit credit_answers_url
    assert_selector "h1", text: "Credit Answers"
  end

  test "creating a Credit answer" do
    visit credit_answers_url
    click_on "New Credit Answer"

    fill_in "Answer", with: @credit_answer.answer
    fill_in "Credit question", with: @credit_answer.credit_question_id
    click_on "Create Credit answer"

    assert_text "Credit answer was successfully created"
    click_on "Back"
  end

  test "updating a Credit answer" do
    visit credit_answers_url
    click_on "Edit", match: :first

    fill_in "Answer", with: @credit_answer.answer
    fill_in "Credit question", with: @credit_answer.credit_question_id
    click_on "Update Credit answer"

    assert_text "Credit answer was successfully updated"
    click_on "Back"
  end

  test "destroying a Credit answer" do
    visit credit_answers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Credit answer was successfully destroyed"
  end
end
