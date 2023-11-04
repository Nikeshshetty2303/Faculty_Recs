class CreateForms < ActiveRecord::Migration[6.1]
  def change
    create_table :forms do |t|
      t.string :name
      t.string :role
      t.integer :salary
      t.string :dept

      t.timestamps
    end
  end
end
