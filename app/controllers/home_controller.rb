class HomeController < ApplicationController
  def index; end
  
  def mock_set
    render :partial => "recent_mock_set", :locals => {:page => params[:page]}
  end
end
