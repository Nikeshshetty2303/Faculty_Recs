class AddColumnToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :role, :string
    add_column :options, :role, :string
  end
end
