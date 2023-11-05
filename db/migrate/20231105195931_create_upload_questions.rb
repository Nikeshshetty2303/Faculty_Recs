class CreateUploadQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_questions do |t|
      t.string :title
      t.references :upload_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
