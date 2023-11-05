class CreateUploadSections < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_sections do |t|
      t.string :title

      t.timestamps
    end
  end
end
