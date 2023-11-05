class AddReferenceToUploadQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :file_uploads, :upload_question, foreign_key: true
  end
end
