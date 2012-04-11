
class ClaimController < ApplicationController

  skip_before_filter :require_authorization

  def index
    if Mockr.unclaimed? && viewer.authenticated?
      graph_data = ActiveSupport::JSON.decode(
        open("http://graph.facebook.com/#{viewer.facebook_uid}").read)
      owner = User.create(:facebook_uid => viewer.facebook_uid,
                          :name => graph_data['name'])
      flash[:notice] = <<-EOS.squish
        Congratulations #{owner.first_name}, you're now the proud owner of this
        brand new instance of Mockr!
      EOS
      redirect_to root_path
    else
      redirect_to new_session_path
    end
  end
end
