class AddColumnCreditToCreditAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_answers, :credit,:float
  end
end
