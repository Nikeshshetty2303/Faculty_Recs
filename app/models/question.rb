class Question < ApplicationRecord
  belongs_to :form
  belongs_to :question_type
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true
end
