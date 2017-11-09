#  class CarsController < ApplicationController
#   before_action :set_car, except: [:index, :new, :create]
#   before_action :authenticate_user!, except: [:show]
#   # before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :location, :update]

#   def index
#     @cars = Car.all
#   end

#   def new
#     @car = current_user.cars.build
#   end

#   def create
#       @car = current_user.cars.build(car_params)
#       # @car = current_user.cars.create(params[:car_params])

#     if @car.save
#       redirect_to new_car_path(@car), notice: "Saved..."
#     else
#       flash[:alert] = "Something went wrong.."
#       render :new
#       end
#   end

#   def show
#     @photos = @car.photos
#   end

#   def listing
  
#   end

#   def pricing
    
#   end

#   def description
#   end

#   def photo_upload
#     @photos = @car.photos
#   end

#   def location
#   end

#   def update
#     new_params = car_params
#     new_params = car_params.merge(active: true) if is_car_ready

#     if @car.update(new_params)
#       flash[:notice] = "Saved.."
#     else 
#       flash[:alert] = "Something went wrong.."
#     end
#       redirect_back(fallback_location: request.referer)
#   end

#   private 
#   def set_car 
#     @car = Car.find(params[:id])
#   end

#   # def is_authorised 
#   #   redirect_to root_path, alert: "You don't have permission", unless current_user.id==@car.user_id
#   # end

#   def is_car_ready
#        is_ready = !@car.active && !@car.price.blank? && !@car.listing_name.blank? && !@car.photos.blank? && !@car.location.blank?
#   end

#   def car_params
#     params.require(:car).permit(:listing_name, :car_type, :transmission, :doors_num, :summary, :price, :active)
#   end
# end 

class CarsController < ApplicationController
  before_action :set_car, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]

  def index
    @cars = current_user.cars
  end

  def new
    @car = current_user.cars.build
  end

  def create
    @car = current_user.cars.build(car_params)
    if @car.save
      redirect_to listing_car_path(@car), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
    end
  end

  def show
    @photos = @car.photos
    @renter_reviews = @car.renter_reviews
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @car.photos
  end

  def location
  end

  def update

    new_params = car_params
    new_params = car_params.merge(active: true) if is_ready_car

    if @car.update(new_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  # --- Reservations ---
  def preload
    today = Date.today
    reservations = @car.reservations.where("start_date >= ? OR end_date >= ?", today, today)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @car)
    }

    render json: output
  end

  private
    def is_conflict(start_date, end_date, car)
      check = car.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
      check.size > 0? true : false
    end

    def set_car
      @car = Car.find(params[:id])
    end

    def is_authorised
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @car.user_id
    end

    def is_ready_car
      !@car.active && !@car.price.blank? && !@car.listing_name.blank? && !@car.photos.blank? && !@car.location.blank?
    end

    def car_params
      params.require(:car).permit(:car_type, :listing_name, :summary, :location, :price, :active)
    end
end



