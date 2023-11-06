class CreditAnswer < ApplicationRecord
  has_many_attached :file_upload
  belongs_to :credit_question, optional: true
  belongs_to :response, optional: true
  belongs_to :credit_section, optional: true
  accepts_nested_attributes_for :credit_question
end
