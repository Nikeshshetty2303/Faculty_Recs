class AddMandatoryColumnToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :mandatory, :boolean, :default => false
  end
end
