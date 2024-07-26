class AddIsSummaryColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :is_summary, :boolean, :default => false
  end
end
