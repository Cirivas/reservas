class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :rut, presence: true, length: { minimum: 9, maximum: 10 }
  validates :membership_number, presence: true, length: { is: 5 }
  validates :email, presence: true, length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { is: 12 }
  validates :country, presence: true, { maximum: 20 }
  validates :birthdate, presence: true
  validates :license_type, presence: true
  validates :license_number, presence: true, { is: 9 }
  validates :user_role, presence: true
  validates :membership_type, presence: true
  validates :membership_state, presence: true
end
