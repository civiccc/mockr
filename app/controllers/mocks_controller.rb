class MocksController < ApplicationController
  def new
  end

  def create
    mock = Mock.new(params[:mock])
    if params[:project]
      if params[:project][:id].blank?
        project_id = Project.create_new_untitled_project!.id
      else
        project_id = params[:project][:id].to_i
      end
      mock.attach_mock_list_if_necessary!(project_id)
    end
    begin
      mock.save!
      mock.deliver(params[:email]) if params[:send_email].to_i == 1
      flash[:notice] = "Mock created!"
      redirect_to mock_path(mock)
    rescue ActiveRecord::RecordInvalid
      render :action => :new
    end
  end

  def show
    @mock = Mock.find(params[:id])
    @last_viewed_at = MockView.last_viewed_at(@mock, viewer) if viewer.real?
    @sidebar = !cookies[:sidebar] || (cookies[:sidebar].first.to_i == 1)
    log_view
    render :layout => "/layouts/mocks/show"
  end

  def index
    @mocks = Mock.recent.all
    respond_to do |format|
      format.atom
    end
  end

  def edit
    @mock = Mock.find(params[:id])
  end
  
  def update
    @mock = Mock.find(params[:id])
    @mock.update_attributes(params[:mock])
    Notifier.deliver_new_mock(@mock)
    flash[:notice] = "Email sent!"
    redirect_to mock_path(@mock)
  end
end
