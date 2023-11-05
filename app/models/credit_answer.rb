class CreditAnswer < ApplicationRecord
  belongs_to :credit_question, optional: true
  accepts_nested_attributes_for :credit_question
end
