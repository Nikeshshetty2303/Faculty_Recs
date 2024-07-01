class ChangeColumnNameInUser < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :adminrole, :role
    change_column :users, :role, :string
  end
end
