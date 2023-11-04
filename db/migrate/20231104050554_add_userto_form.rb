class AddUsertoForm < ActiveRecord::Migration[6.1]
  def change
    add_reference :forms, :user, foreign_key: true
    add_reference :responses, :user, foreign_key: true
    add_column :users, :adminrole, :boolean
  end
end
