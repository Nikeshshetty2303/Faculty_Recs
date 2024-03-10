class AddIsUploadColumnToCredtAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_answers, :is_upload, :boolean
  end
end
