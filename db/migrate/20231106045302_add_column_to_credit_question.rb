class AddColumnToCreditQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_questions, :isheader, :boolean
  end
end
