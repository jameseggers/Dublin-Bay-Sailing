class CoursesController < ActionController::Base
  before_action :set_course

  def show
    @buoys = Buoy.all
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
