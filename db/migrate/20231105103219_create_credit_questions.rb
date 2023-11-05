class CreateCreditQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_questions do |t|
      t.string :title
      t.references :credit_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
