class ReservationMailer < ApplicationMailer

  def confirm_reservation
    @user = params[:user]
    @reservation = params[:reservation]
    @duration = formatted_duration((@reservation.finish_time - @reservation.start_time).to_i)
    mail(to: @user.email, subject: 'Confirmación de reserva')
  end

  def notify_instructor
    @user = params[:user]
    @instructor = params[:instructor]
    @reservation = params[:reservation]
    @duration = formatted_duration((@reservation.finish_time - @reservation.start_time).to_i)
    mail(to: @instructor.email, subject: 'Confirmación de reserva')
  end

  private

  def formatted_duration(total_seconds)
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    "#{ hours } h #{ minutes } m #{ seconds } s"
  end
end
