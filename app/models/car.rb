class Car < ApplicationRecord
  belongs_to :user
  has_many :photos
  has_many :reservations

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  def cover_photo(size)
  if self.photos.length > 0
        self.photos[0].image.url(size)
      else
        "blank.jpg"
 
      end
  end
end
