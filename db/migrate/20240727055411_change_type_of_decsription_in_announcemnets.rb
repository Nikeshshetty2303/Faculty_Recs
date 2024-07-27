class ChangeTypeOfDecsriptionInAnnouncemnets < ActiveRecord::Migration[6.1]
  def change
      change_column :announcements, :description, :text
  end
end
