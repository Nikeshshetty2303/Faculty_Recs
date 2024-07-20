class AddRefBetweenDepAndForm < ActiveRecord::Migration[6.1]
  def change
    add_reference :forms, :department, foriegn_key: true
  end
end
