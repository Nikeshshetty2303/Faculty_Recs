class AddReferenceToCreditQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_questions, :max_credit, :float
    add_column :credit_questions, :obt_credit, :float
    add_reference :credit_answers, :response, foriegn_key: true
    add_reference :file_uploads, :response, foriegn_key: true
  end
end
