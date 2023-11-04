class AddColumnstoForms < ActiveRecord::Migration[7.0]
  def change
    add_column  :forms, :readtime, :integer
    add_column :forms, :description, :text
  end
end
