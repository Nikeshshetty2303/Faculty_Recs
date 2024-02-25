class AddColumnsToForm < ActiveRecord::Migration[6.1]
  def change
    add_column :forms, :fee, :integer 
  end
end
