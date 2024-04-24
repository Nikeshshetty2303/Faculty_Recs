class AddRemarkColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :remark, :string
  end
end
