class CreateTabs < ActiveRecord::Migration[6.1]
  def change
    create_table :tabs do |t|
      t.string :title
      
      t.timestamps
    end
  end
end
