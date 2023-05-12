class UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: [:create]
  before_action :get_user
  
  def index
    users = User.all
    render json: users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: @user
    else
      render json: {errors: "product is not found"} 
    end
  end

  def show
    if @user.present?
      render json: @user
    else
      render json: {errors: "user is not found"}
    end
  end

  def destroy
    @user.destroy
    render json: {code: 200, message: "Successfully deleted"}
  end

  private

  def get_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_digest)
  end

end
