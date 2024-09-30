class AddReferenceMailerStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :referee_mail_status, :boolean
  end
end
