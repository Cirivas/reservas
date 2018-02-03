class Aeroplane < ApplicationRecord

  validates :plate, presence: true, length: { maximum: 6 }
  validates :plane_type, presence: true, length: { maximum: 6 }
  validates :brand, presence: true, length: { maximum: 20 }
  validates :next_revision, presence: true, length: { is: 10 }
  validates :flying_time, presence: true, length: { is: 10 }
  validates :state, presence: true

  has_and_belongs_to_many :users

  def available_hours
    next_revision.to_i - flying_time.to_i
  end
end
