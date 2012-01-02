class HomeController < ApplicationController
  def index
    if params[:uploaded]
      if params[:uploaded].to_i == 1
        flash.now[:notice] = "Mocks uploaded!"
      else
        flash.now[:notice] = "Ruh roh, your mock couldn't be uploaded."
      end
    end
  end
  
  def mock_set
    render :partial => "recent_mock_set", :locals => {:page => params[:page]}
  end
end
