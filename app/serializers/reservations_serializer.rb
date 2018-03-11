class ReservationsSerializer < ActiveModel::Serializer
  attributes :id, :title, :start, :end

  def title
    object.aeroplane.plate
  end

  def start
    object.start_time
  end

  def end
    object.finish_time
  end
end
