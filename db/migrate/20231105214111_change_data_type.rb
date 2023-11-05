class ChangeDataType < ActiveRecord::Migration[6.1]
  def change
    change_column :responses, :credit_score, :float
    add_column :forms, :credit_req, :float
  end
end
