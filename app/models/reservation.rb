class Reservation < ApplicationRecord
  include ActiveModel::Serialization

  belongs_to :user
  belongs_to :aeroplane
  belongs_to :instructor, class_name: 'User', optional: true

  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates :user_id, presence: true
  validates :aeroplane_id, presence: true
  validates :flight_type, presence: true
  
  validate :dates_cannot_be_in_the_past, :finish_time_in_future, :not_on_same_date


  def dates_cannot_be_in_the_past
    if start_time.present? && start_time < Date.today
      errors.add(:start_time, "can't be in the past")
    end

    if finish_time.present? && finish_time < Date.today
      errors.add(:finish_time, "can't be in the past")
    end
  end

  def finish_time_in_future
    if start_time.present? && finish_time.present? && start_time >= finish_time
      errors.add(:finish_time, "must be a superior date")
    end
  end

  def not_on_same_date
    current_time = Time.now
    reservations = Reservation.where('start_time >= ? and aeroplane_id = ?', current_time.to_s, aeroplane_id)

    reservations.each do |res|
      # |sd --- res.sd ----- fd ---- res.fd|
      if res.start_time < finish_time && finish_time < res.finish_time
        errors.add(:finish_time, ": material already reserved in that date")
      end

      # |res.sd --- sd --- res.fd --- fd --- |
      if res.start_time < start_time && start_time < res.finish_time
        errors.add(:start_time, ": material already reserved in that date")
      end

      # |res.sd --- sd --- fd --- res.fd|
      if res.start_time < start_time && finish_time < res.finish_time
        errors.add(:start_time, ": material already reserved in that date (contained)")
      end

      # |sd --- res.sd --- res.fd --- fd|
      if start_time < res.start_time && res.finish_time < finish_time
        errors.add(:finish_time, ": material already reserved in that date (contains)")
      end
    end
  end
end
