class AddColumnVerifiedCreditToCreditAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_answers, :verified_credit,:float
    add_column :credit_answers, :verified_count,:float
  end
end
