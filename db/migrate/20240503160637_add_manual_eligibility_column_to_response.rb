class AddManualEligibilityColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :eligibility, :boolean 
  end
end
