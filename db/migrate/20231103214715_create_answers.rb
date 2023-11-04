class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    drop_table :answers
    create_table :answers do |t|
      t.string :content
      t.references :question, null: false, foreign_key: true
      t.references :response, null: false, foreign_key: true

      t.timestamps
    end
  end
end
