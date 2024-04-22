class AddColumntoUserTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :validator, :boolean
  end
end
