class AddTemplateFormIdToForms < ActiveRecord::Migration[6.1]
  def change
    add_column :forms, :template_form_id, :integer
  end
end
