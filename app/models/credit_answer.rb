class CreditAnswer < ApplicationRecord
  belongs_to :credit_question, optional: true, dependent: :destroy
  belongs_to :response, optional: true, dependent: :destroy
  accepts_nested_attributes_for :credit_question
end
