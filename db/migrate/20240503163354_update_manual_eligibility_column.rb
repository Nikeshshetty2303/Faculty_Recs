class UpdateManualEligibilityColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_default :responses, :eligibility, false
  end
end
