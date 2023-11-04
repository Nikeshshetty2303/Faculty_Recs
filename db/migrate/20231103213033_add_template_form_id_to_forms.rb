class AddTemplateFormIdToForms < ActiveRecord::Migration[7.0]
  def change
    add_column :forms, :template_form_id, :integer
  end
end
