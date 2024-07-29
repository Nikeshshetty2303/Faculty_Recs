class AddSkippedToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :skipped, :string
  end
end
