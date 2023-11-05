class AddColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :credit_score, :integer
  end
end
