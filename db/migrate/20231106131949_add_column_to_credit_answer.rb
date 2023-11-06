class AddColumnToCreditAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :credit_answers, :file_upload, :binary
    add_reference :credit_answers, :credit_section, foriegn_key: true
  end
end
