class CreateCreditAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_answers do |t|
      t.integer :answer
      t.references :credit_question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
