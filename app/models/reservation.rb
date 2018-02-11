class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :aeroplane
  belongs_to :instructor, class_name: 'User'

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
    reservations = Reservation.all
    puts "Model validation"
    puts reservations
    reservations.each do |res|
      if res.id != id && res.aeroplane_id == aeroplane_id
        if res.start_time > start_time && res.start_time < finish_time
          errors.add(:finish_time, ": material already reserved in that date")
        end

        if res.finish_time > start_time && res.finish_time < finish_time
          errors.add(:start_time, ": material already reserved in that date")
        end

        if res.start_time < start_time && res.finish_time > finish_time
          errors.add(:start_time, ": material already reserved in that date")
        end
      end
    end
  end
end
