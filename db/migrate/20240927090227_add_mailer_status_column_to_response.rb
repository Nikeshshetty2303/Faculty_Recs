class AddMailerStatusColumnToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :shortlist_mail_status, :boolean 
  end
end
