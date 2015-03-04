class CourseListing < ActiveRecord::Base
  belongs_to :buoy
  belongs_to :listing
end
