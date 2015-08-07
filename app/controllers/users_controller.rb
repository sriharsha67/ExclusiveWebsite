class UsersController < ApplicationController

  def create
    @user=User.new(user_params)
    if @user.save
      redirect_to waiting_path
    else
      redirect_to root_path, alert: "Please enter your name and email"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
