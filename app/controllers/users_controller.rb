class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      flash[:notice] = "No user with id #{params[:id]}"
      redirect_to users_path
    else
     @activities =  PublicActivity::Activity.where(:owner_id => params[:id]).order(:created_at).reverse_order
    end
  end

end
