class Car < ApplicationRecord
  belongs_to :user
  has_many :photos
  has_many :reservations

  has_many :renter_reviews

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  def cover_photo(size)
  if self.photos.length > 0
        self.photos[0].image.url(size)
      else
        "blank.jpg"
      end
  end
    def average_rating
    renter_reviews.count == 0 ? 0 : renter_reviews.average(:star).round(2).to_i
  end
end
