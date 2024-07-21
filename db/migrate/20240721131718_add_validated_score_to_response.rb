class AddValidatedScoreToResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :responses, :validated_credit_score, :float
  end
end
