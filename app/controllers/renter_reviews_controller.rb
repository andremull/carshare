class RenterReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exist (car_id, owner_id, owner_id)

    # Step 2: Check if the current owner already reviewed the renter in this reservation.

    @reservation = Reservation.where(
                    id: renter_review_params[:reservation_id],
                    car_id: renter_review_params[:car_id]
                   ).first

    if !@reservation.nil? && @reservation.car.user.id == renter_review_params[:owner_id].to_i

      @has_reviewed = RenterReview.where(
                        reservation_id: @reservation.id,
                        owner_id: renter_review_params[:owner_id]
                      ).first

      if @has_reviewed.nil?
          # Allow to review
          @renter_review = current_user.renter_reviews.create(renter_review_params)
          flash[:success] = "Review created..."
      else
          # Already reviewed
          flash[:success] = "You already reviewed this Reservation"
      end
    else
      flash[:alert] = "Not found this reservation"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @renter_review = Review.find(params[:id])
    @renter_review.destroy

    redirect_back(fallback_location: request.referer, notice: "Removed...!")
  end

  private
    def renter_review_params
      params.require(:renter_review).permit(:comment, :star, :car_id, :reservation_id, :owner_id)
    end
end