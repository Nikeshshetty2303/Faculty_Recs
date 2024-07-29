class ChangeAppNoType < ActiveRecord::Migration[6.1]
  def change
    change_column :responses, :app_no, :string
  end
end
