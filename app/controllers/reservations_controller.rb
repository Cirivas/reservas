class ReservationsController < ApplicationController

  before_action :authenticate_any!
  before_action :minutes, only: [:edit, :new]
  before_action :set_reservation, only: [:edit, :update, :show, :destroy]

  def index
    @reservations = Reservation.all
  end

  def new
    @reservation = Reservation.new
  end

  def load_aeroplanes
    qualifications = User.find(params[:id]).aeroplanes

    respond_to do |format|
      format.json { render json: qualifications }
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    
    if @reservation.save
      flash[:success] = "Reserva creada correctamente"
      redirect_to @reservation
    else
      minutes
      render action: 'new'
    end
  end

  def edit
  end
  
  def update
    if @reservation.update_attributes(reservation_params)
      @flash[:success] = "Reserva actualizada correctamente"
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
end
