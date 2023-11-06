class CreditQuestion < ApplicationRecord
  belongs_to :credit_section, optional: true
  belongs_to :header, class_name: "CreditQuestion", foreign_key: "header_id", optional: true
  has_many :sub_questions, class_name: "CreditQuestion", foreign_key: "header_id"
  
end
