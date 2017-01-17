class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Uspešno ste se ulogovali!"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "Nešto nije uredu sa vašim login podacima"
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Izlogovali ste se"
    redirect_to root_path
  end
end