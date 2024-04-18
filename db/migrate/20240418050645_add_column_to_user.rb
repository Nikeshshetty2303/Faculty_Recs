class AddColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nav_tab_no, :integer, :default =>1
    change_column_default :users, :tab_no, 1
  end
end
