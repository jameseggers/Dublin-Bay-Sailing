class CoursesController < ActionController::Base
  before_action :set_course, except: :index

  def index
    @courses = Course.all
    @listings = Listing.all#.group_by { |o| o.course_id }
    @buoys = Buoy.all
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
