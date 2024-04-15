class AddReferenceForTabs < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :tab, foriegn_key: true
    add_column :users, :tab_no, :integer, :default =>0
  end
end
