class ChangeSpecializationDataType < ActiveRecord::Migration[6.1]
  def change
    change_column :responses, :specialization, :boolean
  end
end
