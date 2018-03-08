class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :aeroplanes
  has_many :reservations
  has_many :coflights, class_name: 'Reservation', foreign_key: 'instructor_id'

  validates :rut, presence: true, length: { minimum: 9, maximum: 10 }
  validates :membership_number, presence: true, length: { is: 5 }
  validates :email, presence: true, length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { is: 9 }
  validates :country, presence: true, length: { maximum: 20 }
  validates :birthdate, presence: true
  validates :license_type, presence: true
  validates :license_number, presence: true, length: { is: 9 }
  validates :user_role, presence: true
  validates :membership_type, presence: true
  validates :membership_state, presence: true

  def is_admin?
    if user_role == 1
      true
    else
      false
    end
  end
end
