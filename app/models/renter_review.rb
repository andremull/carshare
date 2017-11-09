class RenterReview < Review
    belongs_to :renter, class_name: "User"
end
