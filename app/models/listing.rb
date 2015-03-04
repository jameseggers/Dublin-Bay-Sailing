class Listing < ActiveRecord::Base
  has_many :course_listings
  has_many :buoys, through: :course_listings
end
