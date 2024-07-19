class AddStatusColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :status, :string, default: 'Free'
  end
end
