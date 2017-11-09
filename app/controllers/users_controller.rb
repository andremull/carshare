class UsersController < ApplicationController

    def show
        @user = User.find(params[:id])
        @cars = @user.cars

    @renter_reviews = Review.where(type: "RenterReview", owner_id: @user.id)

  
    @owner_reviews = Review.where(type: "OwnerReview", renter_id: @user.id)
    end

end