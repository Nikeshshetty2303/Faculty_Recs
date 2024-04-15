class Tab < ApplicationRecord
    has_many :questions, -> { order(position: :asc) }, dependent: :destroy
end
