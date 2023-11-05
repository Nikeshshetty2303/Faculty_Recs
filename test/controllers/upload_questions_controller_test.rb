require "test_helper"

class UploadQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upload_question = upload_questions(:one)
  end

  test "should get index" do
    get upload_questions_url
    assert_response :success
  end

  test "should get new" do
    get new_upload_question_url
    assert_response :success
  end

  test "should create upload_question" do
    assert_difference('UploadQuestion.count') do
      post upload_questions_url, params: { upload_question: { title: @upload_question.title, upload_section_id: @upload_question.upload_section_id } }
    end

    assert_redirected_to upload_question_url(UploadQuestion.last)
  end

  test "should show upload_question" do
    get upload_question_url(@upload_question)
    assert_response :success
  end

  test "should get edit" do
    get edit_upload_question_url(@upload_question)
    assert_response :success
  end

  test "should update upload_question" do
    patch upload_question_url(@upload_question), params: { upload_question: { title: @upload_question.title, upload_section_id: @upload_question.upload_section_id } }
    assert_redirected_to upload_question_url(@upload_question)
  end

  test "should destroy upload_question" do
    assert_difference('UploadQuestion.count', -1) do
      delete upload_question_url(@upload_question)
    end

    assert_redirected_to upload_questions_url
  end
end
