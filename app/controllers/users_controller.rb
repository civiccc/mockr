class UsersController < ApplicationController
  def create
    begin
      user = User.new(params[:user])
      user.save!
      flash[:notice] = "User added!"
    rescue => ex
      flash[:notice] = "That user could not be added."
    end
    redirect_to users_path
  end

  def new
    @user = User.new(:active => true)
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.active.all(:order => 'name')
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    flash[:notice] = "Your changes have been saved."
    redirect_to users_path
  end
end
