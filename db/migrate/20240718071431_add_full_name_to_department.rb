class AddFullNameToDepartment < ActiveRecord::Migration[6.1]
  def change
    add_column :departments, :full_name, :string
  end
end
