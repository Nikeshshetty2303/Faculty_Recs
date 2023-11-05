class CreateFileUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :file_uploads do |t|
      t.binary :file

      t.timestamps
    end
  end
end
