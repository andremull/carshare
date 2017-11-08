class CarsController < ApplicationController
  before_action :set_car, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  # before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :location, :update]

  def index
    @cars = current_user.cars
  end

  def new
    @car = current_user.cars.build
  end

  def create
      @car = current_user.cars.build(car_params)
      # @car = current_user.cars.create(params[:car_params])

    if @car.save
      redirect_to new_car_path(@car), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong.."
      render :new
      end
  end

  def show
    @photos = @car.photos
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
    new_params = car_params.merge(active: true) if is_car_ready

    if @car.update(new_params)
      flash[:notice] = "Saved.."
    else 
      flash[:alert] = "Something went wrong.."
    end
      redirect_back(fallback_location: request.referer)
  end

  private 
  def set_car 
    @car = Car.find(params[:id])
  end

  # def is_authorised 
  #   redirect_to root_path, alert: "You don't have permission", unless current_user.id==@car.user_id
  # end

  def is_car_ready
       is_ready = !@car.active && !@car.price.blank? && !@car.listing_name.blank? && !@car.photos.blank? && !@car.location.blank?
  end

  def car_params
    params.require(:car).permit(:listing_name, :car_type, :transmission, :doors_num, :summary, :price, :active)
  end
end


