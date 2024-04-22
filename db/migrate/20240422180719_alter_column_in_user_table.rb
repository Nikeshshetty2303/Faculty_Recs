class AlterColumnInUserTable < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :validator, :string 
  end
end
