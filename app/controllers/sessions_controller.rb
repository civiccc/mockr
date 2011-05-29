class SessionsController < ApplicationController
  layout nil

  skip_before_filter :require_authorization

  def index
    redirect_to new_session_path
  end

  def new
    if viewer.authorized?
      redirect_to params[:next_url] || root_path
    end
  end

  def destroy
    cookies.delete(FacebookCookies.fb_cookie_key)
    flash[:notice] = "Thank you, come again!"
    redirect_to new_session_path
  end
end
