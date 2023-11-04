class AddColumnstoForms < ActiveRecord::Migration[6.1]
  def change
    add_column  :forms, :readtime, :integer
    add_column :forms, :description, :text
  end
end
