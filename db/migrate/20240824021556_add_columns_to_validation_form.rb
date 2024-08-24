class AddColumnsToValidationForm < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :undergraduate, :string
    add_column :responses, :postgraduate, :string
    add_column :responses, :phd, :string
    add_column :responses, :postdoc , :string
    add_column :responses, :experience_type, :string
    add_column :responses, :major_awards, :string
    add_column :responses, :acad_exp_comments, :string
    add_column :responses, :prof_exp_comments, :string
    add_column :responses, :credit_req_comments, :string
  end
end
