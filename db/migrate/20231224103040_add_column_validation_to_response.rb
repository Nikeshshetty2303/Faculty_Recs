class AddColumnValidationToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :validation, :boolean
  end
end
