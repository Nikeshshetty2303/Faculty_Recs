class AddPositionToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :position, :integer
    Form.all.each do |form|
  form.questions.order(:updated_at).each.with_index(1) do |ques, index|
    ques.update_column :position, index
  end
end
  end
end
