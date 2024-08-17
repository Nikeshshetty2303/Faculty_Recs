class AddValidationColumnsToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :academic_experience, :boolean
    add_column :responses, :professional_experience, :boolean
    add_column :responses, :credit_requirements, :boolean
  end
end
