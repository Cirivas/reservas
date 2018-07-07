class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :aeroplanes
  has_many :reservations, dependent: :destroy
  has_many :coflights, class_name: 'Reservation', foreign_key: 'instructor_id', dependent: :destroy

  validates :rut, presence: true, length: { minimum: 7, maximum: 10 }
  validates :membership_number, presence: true, length: { maximum: 5 }
  validates :email, presence: true, length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone, length: { maximum: 9 }
  validates :country, presence: true, length: { maximum: 20 }
  validates :birthdate, presence: true
  validates :license_type, presence: true
  validates :license_number, presence: true, length: { maximum: 9 }
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

  def is_qualified?(aeroplane_id)
    found = false
    aeroplanes.each do |a|
      if a.id.to_i == aeroplane_id.to_i
        found = true
        break
      end
    end
    found
  end

  def full_name
    "#{name} #{last_name}"
  end
end
