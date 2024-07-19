class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :forms, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_one_attached :photo, dependent: :destroy
  has_one_attached :sign, dependent: :destroy
  

end
