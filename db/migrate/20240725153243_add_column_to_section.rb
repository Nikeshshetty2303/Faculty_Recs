class AddColumnToSection < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_sections, :max_credit, :float
  end
end
