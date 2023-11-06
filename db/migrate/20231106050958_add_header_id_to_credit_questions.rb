class AddHeaderIdToCreditQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_questions, :header_id, :integer
     add_foreign_key :credit_questions, :credit_questions, column: :header_id, on_delete: :cascade
  end
end
