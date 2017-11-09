class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    car = Car.find(params[:car_id])

    if current_user == car.user
      flash[:alert] = "You cannot book your own car!"
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      days = (end_date - start_date).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.car = car
      @reservation.price = car.price
      @reservation.total = car.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully!"
    end
    redirect_to car
  end

  def your_trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  def your_reservations
    @cars = current_user.cars
  end

  private
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date)
    end
end
