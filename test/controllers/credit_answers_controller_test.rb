require "test_helper"

class CreditAnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit_answer = credit_answers(:one)
  end

  test "should get index" do
    get credit_answers_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_answer_url
    assert_response :success
  end

  test "should create credit_answer" do
    assert_difference('CreditAnswer.count') do
      post credit_answers_url, params: { credit_answer: { answer: @credit_answer.answer, credit_question_id: @credit_answer.credit_question_id } }
    end

    assert_redirected_to credit_answer_url(CreditAnswer.last)
  end

  test "should show credit_answer" do
    get credit_answer_url(@credit_answer)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_answer_url(@credit_answer)
    assert_response :success
  end

  test "should update credit_answer" do
    patch credit_answer_url(@credit_answer), params: { credit_answer: { answer: @credit_answer.answer, credit_question_id: @credit_answer.credit_question_id } }
    assert_redirected_to credit_answer_url(@credit_answer)
  end

  test "should destroy credit_answer" do
    assert_difference('CreditAnswer.count', -1) do
      delete credit_answer_url(@credit_answer)
    end

    assert_redirected_to credit_answers_url
  end
end
