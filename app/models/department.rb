class Department < ApplicationRecord
    has_many :forms, dependent: :destroy
end
