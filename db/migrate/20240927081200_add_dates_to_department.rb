class AddDatesToDepartment < ActiveRecord::Migration[6.1]
  def change
    add_column :departments, :s1_reporting_date, :string
    add_column :departments, :s1_reporting_time, :string
    add_column :departments, :s2_reporting_date, :string
    add_column :departments, :s2_reporting_time, :string
    add_column :departments, :s3_reporting_date_and_time, :string
  end
end
