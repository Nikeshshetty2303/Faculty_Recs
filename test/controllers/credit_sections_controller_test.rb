require "test_helper"

class CreditSectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @credit_section = credit_sections(:one)
  end

  test "should get index" do
    get credit_sections_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_section_url
    assert_response :success
  end

  test "should create credit_section" do
    assert_difference('CreditSection.count') do
      post credit_sections_url, params: { credit_section: { title: @credit_section.title } }
    end

    assert_redirected_to credit_section_url(CreditSection.last)
  end

  test "should show credit_section" do
    get credit_section_url(@credit_section)
    assert_response :success
  end

  test "should get edit" do
    get edit_credit_section_url(@credit_section)
    assert_response :success
  end

  test "should update credit_section" do
    patch credit_section_url(@credit_section), params: { credit_section: { title: @credit_section.title } }
    assert_redirected_to credit_section_url(@credit_section)
  end

  test "should destroy credit_section" do
    assert_difference('CreditSection.count', -1) do
      delete credit_section_url(@credit_section)
    end

    assert_redirected_to credit_sections_url
  end
end
