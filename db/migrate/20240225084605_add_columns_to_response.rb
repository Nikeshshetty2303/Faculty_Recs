class AddColumnsToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :payment_status,:boolean
    add_column :responses, :amount, :interger
  end
end
