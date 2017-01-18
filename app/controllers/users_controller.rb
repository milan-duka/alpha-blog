class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    flash[:danger] = "Poštovani, izvinjavamo se. Privremeno je onemogućena registracija novih korisnika."
    redirect_to root_path
    # @user = User.new
  end
  
  def create
    flash[:danger] = "Poštovani, izvinjavamo se. Privremeno je onemogućena registracija novih korisnika."
    redirect_to root_path
    # @user = User.new(user_params)
    # if @user.save
    #   session[:user_id] = @user.id
    #   flash[:success] = "Dobrodošli na Kibitz Fenster #{@user.username}"
    #   redirect_to user_path(@user)
    # else
    #   render 'new'
    # end
  end
  
  def edit
  end
  
  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Korisnički podaci su uspešno sačuvani"
      redirect_to articles_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:danger] = "Korisnik i sve njegove objave su uspešno obrisani"
    redirect_to users_path
  end
  
  private
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  def require_same_user
    if logged_in?
      if current_user != @user && !current_user.admin?
        flash[:danger] = "Možete da menjate isključivo sopstevni nalog"
        redirect_to root_path
      end
    else
      flash[:danger] = "Morate se ulogovati kako biste izvršili ovu akciju"
      redirect_to root_path
    end
  end
  
  def require_admin
    if logged_in? 
      if !current_user.admin?
        flash[:danger] = "Samo administrator može da izvrši ovu akciju"
        redirect_to root_path
      end
    else
      flash[:danger] = "Samo administrator može da izvrši ovu akciju"
      redirect_to root_path
    end
  end
end