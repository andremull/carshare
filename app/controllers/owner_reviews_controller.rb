class OwnerReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exist (car_id, renter_id, owner_id)

    # Step 2: Check if the current owner already reviewed the renter in this reservation.

    @reservation = Reservation.where(
                    id: owner_review_params[:reservation_id],
                    car_id: owner_review_params[:car_id],
                    user_id: owner_review_params[:renter_id]
                   ).first

    if !@reservation.nil?

      @has_reviewed = OwnerReview.where(
                        reservation_id: @reservation.id,
                        renter_id: owner_review_params[:renter_id]
                      ).first

      if @has_reviewed.nil?
          # Allow to review
          @owner_review = current_user.owner_reviews.create(owner_review_params)
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
    @owner_review = Review.find(params[:id])
    @owner_review.destroy

    redirect_back(fallback_location: request.referer, notice: "Removed...!")
  end

  private
    def owner_review_params
      params.require(:owner_review).permit(:comment, :star, :car_id, :reservation_id, :renter_id)
    end
end