class ChangeRefereeMailStatusDataType < ActiveRecord::Migration[6.1]
  def change
    change_column :responses, :referee_mail_status, :string
  end
end
