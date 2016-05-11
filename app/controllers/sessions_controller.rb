class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # si la checkbox est checké ça retourne '1' aussi nnon '0'
      remember user # créer un token remember_digest dans la db
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'   
      render 'new'
    end
  end

  def destroy
  	log_out if logged_in? # si l'utilsateur est connecté on se peut se déconnecté / c'est pour éviter l'erreur si on se redéconnecte dans une autre fenetre
    redirect_to root_url
  end
end
