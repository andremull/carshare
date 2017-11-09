class PagesController < ApplicationController
  def home
    @cars = Car.where(active: true).limit(3)
  end

  def search
    # STEP 1
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    # STEP 2
    if session[:loc_search] && session[:loc_search] != ""
      @cars_location = Car.where(active: true).near(session[:loc_search], 10, order: 'distance')
    else
      @cars_location = Car.where(active: true).all
    end

    # STEP 3
    @search = @cars_location.ransack(params[:q])
    @cars = @search.result

    @arrcars = @cars.to_a

    # STEP 4
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @cars.each do |car|

        not_available = car.reservations.where(
          "(? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date)",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date
        ).limit(1)

        if not_available.length > 0
          @arrcars.delete(car)
        end
      end
    end

  end
end
