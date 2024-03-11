class ChangeDataTypeOfSalaryInForm < ActiveRecord::Migration[6.1]
  def change
    change_column :forms, :salary, :string
  end
end
