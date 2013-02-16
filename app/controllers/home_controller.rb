class HomeController < ApplicationController
  def index
    @recent = Mock.joins(:mock_views).
      where('mock_views.user_id = ?', viewer.id).
      order('mock_views.viewed_at DESC').
      limit(3)
  end

  def mock_set
    render :partial => 'recent_mock_set', :locals => {:page => params[:page]}
  end
end
