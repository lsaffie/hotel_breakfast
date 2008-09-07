class UsersController < ApplicationController
  
before_filter :login_required

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem


  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/login')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def list
    @users = User.find(:all)
  end

  def index
    @users = User.find(:all)
  end
  
  def destroy
    if User.find(:all)[1]
      User.find(params[:id]).destroy
      redirect_to :action => 'index'
    else
      flash[:notice] = "Can't delete this user"
      redirect_to :action => 'index'
    end
  end

end
