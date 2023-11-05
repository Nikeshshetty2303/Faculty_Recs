require "test_helper"

class CreditQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit_question = credit_questions(:one)
  end

  test "should get index" do
    get credit_questions_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_question_url
    assert_response :success
  end

  test "should create credit_question" do
    assert_difference('CreditQuestion.count') do
      post credit_questions_url, params: { credit_question: { credit_section_id: @credit_question.credit_section_id, title: @credit_question.title } }
    end

    assert_redirected_to credit_question_url(CreditQuestion.last)
  end

  test "should show credit_question" do
    get credit_question_url(@credit_question)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_question_url(@credit_question)
    assert_response :success
  end

  test "should update credit_question" do
    patch credit_question_url(@credit_question), params: { credit_question: { credit_section_id: @credit_question.credit_section_id, title: @credit_question.title } }
    assert_redirected_to credit_question_url(@credit_question)
  end

  test "should destroy credit_question" do
    assert_difference('CreditQuestion.count', -1) do
      delete credit_question_url(@credit_question)
    end

    assert_redirected_to credit_questions_url
  end
end
