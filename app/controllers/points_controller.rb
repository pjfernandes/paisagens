class PointsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @points = Point.all
    @point = Point.new
  end

  def show
    @point = Point.find(params[:id])
  end

  def new
    @point = Point.new
  end

  def create
    @point = Point.new(point_params)
    @point.user_id = current_user.id
    @point.user_email = current_user.email

    if @point.save
      redirect_to points_path, notice: 'Point was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @point = Point.find(params[:id])
    @point.destroy
    redirect_to points_url, notice: 'Point was successfully destroyed.'
  end

  private

  def point_params
    params.require(:point).permit(:latitude, :longitude, :name, :description, :user_id, :user_email)
  end
end
