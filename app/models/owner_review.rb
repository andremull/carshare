class OwnerReview < Review
    belongs_to :owner, class_name: "User"
end
