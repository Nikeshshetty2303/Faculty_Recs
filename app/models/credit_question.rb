class CreditQuestion < ApplicationRecord
  belongs_to :credit_section, optional: true
end
