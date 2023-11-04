class CreateQuestionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :question_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
