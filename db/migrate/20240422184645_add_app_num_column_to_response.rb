class AddAppNumColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :app_no, :integer
  end
end
