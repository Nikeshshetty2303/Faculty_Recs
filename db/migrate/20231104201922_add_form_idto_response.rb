class AddFormIdtoResponse < ActiveRecord::Migration[6.1]
  def change
    add_reference :responses, :form, foriegn_key: true
  end
end
