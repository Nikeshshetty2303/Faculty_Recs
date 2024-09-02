class AddSpecializationColumnAndUpdateEligibilityDataType < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :specialization, :string
    change_column :responses, :eligibility, :string
  end
end
