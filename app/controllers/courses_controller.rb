class CoursesController < ActionController::Base
  def show
    render json: Course.find(params[:course_id])
  end
end
