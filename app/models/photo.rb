class Photo < ApplicationRecord
  belongs_to :car
  
  has_attached_file :image, styles: { original:"75x75>", medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  end

