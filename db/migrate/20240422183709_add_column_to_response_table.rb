class AddColumnToResponseTable < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :profile_response, :boolean
  end
end
