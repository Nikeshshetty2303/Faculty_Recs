class Question < ApplicationRecord
  belongs_to :form
  belongs_to :question_type
  acts_as_list scope: :form
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
end
