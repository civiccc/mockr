class ClaimController < ApplicationController

  skip_before_filter :require_authorization

  def index
    if Mockr.unclaimed? && viewer.authenticated?
      owner = User.create(:facebook_uid => viewer.facebook_uid, :name => cookies["fbname"])
      flash[:notice] = "Congratulations #{owner.first_name}, you're now the proud owner of this brand new instance of Mockr!"
      redirect_to root_path
    else
      redirect_to new_session_path
    end
  end
end
