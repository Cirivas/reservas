class ReservationsController < ApplicationController

  before_action :authenticate_any!
  before_action :minutes, only: [:edit, :new]
  before_action :set_reservation, only: [:edit, :update, :show, :destroy]
  before_action :check_availability, only: [:new, :edit, :update, :destroy]

  def index
    if params[:start].present?
      start_time = params[:start]
      finish_time = params[:end]
    else
      start_time = Date.today.beginning_of_month
      finish_time = Date.today.end_of_month
    end
    @reservations = Reservation.where('start_time >= ? and finish_time <= ?', start_time, finish_time)
    respond_to do |format|
      format.html
      format.json { render json: ActiveModel::ArraySerializer.new(@reservations, each_serializer: ReservationsSerializer).to_json }
    end
  end

  def new
    @reservation = Reservation.new

    if params[:start].present?
      @reservation.start_time = params[:start]
      @reservation.finish_time = params[:start]
    end
  end

  def load_aeroplanes
    qualifications = User.find(params[:id]).aeroplanes

    respond_to do |format|
      format.json { render json: qualifications }
    end
  end

  def create
    qualified = false
    if user_signed_in? && !current_user.is_admin?
      if current_user.is_qualified?(params[:reservation][:aeroplane_id])
        params[:reservation].delete(:instructor_id)
        qualified = true
      end      
      @reservation = Reservation.new(reservation_params)
      @reservation.user_id = current_user.id 
    elsif (user_signed_in? && current_user.is_admin?) || admin_signed_in? 
      if User.find(params[:reservation][:user_id]).is_qualified?(params[:reservation][:aeroplane_id])
        params[:reservation].delete(:instructor_id)
        qualified = true
      end
      @reservation = Reservation.new(reservation_params)
    end
    
    if @reservation.save
      flash[:success] = "Reserva creada correctamente"

      if user_signed_in? && !current_user.is_admin?
        ReservationMailer.with(user: current_user, reservation: @reservation).confirm_reservation.deliver_later
        ReservationMailer.with(user: current_user, reservation: @reservation, instructor: User.find(params[:reservation][:instructor_id])).notify_instructor.deliver_later unless qualified
      elsif (user_signed_in? && current_user.is_admin?) || admin_signed_in? 
        ReservationMailer.with(user: User.find(params[:reservation][:user_id]), reservation: @reservation).confirm_reservation.deliver_later
        ReservationMailer.with(user: User.find(params[:reservation][:user_id]), reservation: @reservation, instructor: User.find(params[:reservation][:instructor_id])).notify_instructor.deliver_later unless qualified
      end

      redirect_to @reservation
    else
      minutes
      render action: 'new'
    end
  end

  def edit
    if user_signed_in? && @reservation.user != current_user && !current_user.is_admin?
      redirect_to reservations_path
    end
  end
  
  def update
    qualified = false
    if user_signed_in? && !current_user.is_admin?
      if current_user.is_qualified?(params[:reservation][:aeroplane_id])
        params[:reservation].delete(:instructor_id)
        qualified = true
      end
    elsif (user_signed_in? && current_user.is_admin?) || admin_signed_in? 
      user = User.find(params[:reservation][:user_id])
      if user.is_qualified?(params[:reservation][:aeroplane_id])
        params[:reservation].delete(:instructor_id)
        qualified = true
      end
    end

    if @reservation.update_attributes(reservation_params)
      flash[:success] = "Reserva actualizada correctamente"

      if user_signed_in? && !current_user.is_admin?
        ReservationMailer.with(user: current_user, reservation: @reservation).confirm_change_reservation.deliver_later
        ReservationMailer.with(user: current_user, reservation: @reservation, instructor: User.find(params[:reservation][:instructor_id])).notify_change_instructor.deliver_later unless qualified
      elsif (user_signed_in? && current_user.is_admin?) || admin_signed_in? 
        ReservationMailer.with(user: User.find(params[:reservation][:user_id]), reservation: @reservation).confirm_change_reservation.deliver_later
        ReservationMailer.with(user: User.find(params[:reservation][:user_id]), reservation: @reservation, instructor: User.find(params[:reservation][:instructor_id])).notify_change_instructor.deliver_later unless qualified
      end

      redirect_to @reservation
    else
      minutes
      render action: 'edit'
    end
  end
  
  def destroy
    if @reservation.destroy
      flash[:success] = "Reserva eliminada correctamente"
    else
      flash[:error] = "No se pudo eliminar su reserva"
    end

    redirect_to reservations_path
  end

  def show
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :finish_time, :user_id, :instructor_id, :aeroplane_id, :flight_type, :route)
  end

  def minutes
    @minutes = DateTime.now
    adjust = (@minutes.minute.to_f / 15.0).ceil * 15
    @minutes += (adjust - @minutes.minute).minutes
  end

  def set_hours
    start_time = DateTime.now
    end_time = DateTime.now.end_of_day

    adjust = (start_time.minute.to_f / 15.0).ceil * 15
    start_time += (adjust - start_time.minute).minutes

    hm = start_time.hour.to_s + ":" + start_time.minute.to_s
    if start_time.minute.to_s == "0"
      hm += "0"
    end
    @times = [[hm, hm]]
    while start_time < end_time
      start_time += 15.minutes
      hm = start_time.hour.to_s + ":" + start_time.minute.to_s
      if start_time.minute.to_s == "0"
        hm += "0"
      end
      @times << [hm, hm]
    end 

    if start_time.day > DateTime.now.day
      @times.pop
    end
  end

  def check_availability
    if current_user && !current_user.is_available?
      flash[:error] = "No estás habilitado para realizar reservas"
      redirect_to reservations_path
    end
  end
end
