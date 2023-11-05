class CreditAnswer < ApplicationRecord
  belongs_to :credit_question, optional: true
  belongs_to :response, optional: true
  accepts_nested_attributes_for :credit_question
end
