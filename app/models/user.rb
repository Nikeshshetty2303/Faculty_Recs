class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :forms
  has_many :responses, dependent: :destroy
  has_one_attached :photo, dependent: :destroy
  has_one_attached :sign, dependent: :destroy

  def self.delete_unconfirmed
    where(confirmed_at: nil)
      .where('created_at < ?', 30.minutes.ago)
      .destroy_all
  end

end
