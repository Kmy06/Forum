class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # Par défaut,les filtres s'applicablent à chaque action dans un contrôleur, donc ici, nous limitons le filtre d'agir uniquement sur update et edit des actions en passant seulement les options de hachage
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy # seul l'administrateur peut effacer des utilisateurs

  def index
    # Ici, le paramètre de page vient de params [: page], qui est généré automatiquement par will_paginate
    # paginate prend un argument de hachage avec la clé: page et de valeur égale à la page demandée
    @users = User.paginate(page: params[:page]) 
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

	def create
		@user = User.new(user_params)
		if @user.save
      log_in @user
      flash[:success] = "Welcome"
      redirect_to @user
		else
		render 'new'
	  	end
	end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

	 private

    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user # sauf si
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
