require "application_system_test_case"

class CreditSectionsTest < ApplicationSystemTestCase
  setup do
    @credit_section = credit_sections(:one)
  end

  test "visiting the index" do
    visit credit_sections_url
    assert_selector "h1", text: "Credit Sections"
  end

  test "creating a Credit section" do
    visit credit_sections_url
    click_on "New Credit Section"

    fill_in "Title", with: @credit_section.title
    click_on "Create Credit section"

    assert_text "Credit section was successfully created"
    click_on "Back"
  end

  test "updating a Credit section" do
    visit credit_sections_url
    click_on "Edit", match: :first

    fill_in "Title", with: @credit_section.title
    click_on "Update Credit section"

    assert_text "Credit section was successfully updated"
    click_on "Back"
  end

  test "destroying a Credit section" do
    visit credit_sections_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Credit section was successfully destroyed"
  end
end
