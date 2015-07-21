class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      status = 201
      flash[:success] = "Valid signin credentials.  You just signed in!"
      redirect_to user_path(user)
    else
      status = 400
      flash[:error] = "Invalid signin credentials.  You were not signed in!"
      render 'new'
    end
  end

  def destroy

  end
end