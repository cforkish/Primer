class UsersController < ApplicationController

  def show
    @user = User.find_by_username!(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Primer!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by_username!(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :username,
                                   :password, :password_confirmation)
    end

end
