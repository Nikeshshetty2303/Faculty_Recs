class Relations < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :form, foreign_key: true
    add_reference :questions, :question_type, foreign_key: true
    add_reference :options, :question, foreign_key: true
  end
end
