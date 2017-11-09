class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :confirmable, :omniauthable

  validates :fullname, presence: true, length: {maximum: 50}

  has_many :cars
  has_many :reservations
  
  has_many :renter_reviews, class_name: "RenterReview", foreign_key: "renter_id"
  has_many :owner_reviews, class_name: "OwnerReview", foreign_key: "owner_id"

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user
      return user
    else
         where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.fullname = auth.info.name   
    user.image = auth.info.image 
    user.uid = auth.uid
    user.provider = auth.provider

    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
     user.skip_confirmation!
        end

      end
  end

end
