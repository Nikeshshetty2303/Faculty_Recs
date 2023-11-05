require "test_helper"

class UploadSectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upload_section = upload_sections(:one)
  end

  test "should get index" do
    get upload_sections_url
    assert_response :success
  end

  test "should get new" do
    get new_upload_section_url
    assert_response :success
  end

  test "should create upload_section" do
    assert_difference('UploadSection.count') do
      post upload_sections_url, params: { upload_section: { title: @upload_section.title } }
    end

    assert_redirected_to upload_section_url(UploadSection.last)
  end

  test "should show upload_section" do
    get upload_section_url(@upload_section)
    assert_response :success
  end

  test "should get edit" do
    get edit_upload_section_url(@upload_section)
    assert_response :success
  end

  test "should update upload_section" do
    patch upload_section_url(@upload_section), params: { upload_section: { title: @upload_section.title } }
    assert_redirected_to upload_section_url(@upload_section)
  end

  test "should destroy upload_section" do
    assert_difference('UploadSection.count', -1) do
      delete upload_section_url(@upload_section)
    end

    assert_redirected_to upload_sections_url
  end
end
