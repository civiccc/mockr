class MocksController < ApplicationController
  # Allow 3rd party services to access the atom feed.
  skip_before_filter :require_authorization, :only => :index

  def new
    if params[:failed]
      flash.now[:notice] = "Ruh roh, your mock couldn't be uploaded."
    end
  end

  def create
    mocks = params[:images].map do |image|
      Mock.new(params[:mock].merge(:image => image))
    end
    project_id = params[:project_id].blank? ?
      Project.create_new_untitled_project!.id : params[:project_id]
    mocks.each_with_index do |mock, i|
      title = File.basename(mock.image_file_name,
        File.extname(mock.image_file_name))
      title = title.titleize
      mock.attach_mock_list_if_necessary!(project_id, title)
      mock.save!
    end
    url = mock_url(mocks.first)
    Campfire.notify_mocks_created(mocks, url)
    render :json => {
      :mocks_count => mocks.size,
      :mock_ids => mocks.map(&:id),
      :project_id => project_id
    }
  end

  def show
    @mock = Mock.find(params[:id])
    @last_viewed_at = MockView.last_viewed_at(@mock, viewer) if viewer.real?
    log_view
    render :layout => "/layouts/mocks/show"
  end

  def index
    @mocks = Mock.recent(50).all
    respond_to do |format|
      format.atom
    end
  end

  def destroy
    @mock = Mock.find(params[:id])
    project = @mock.project
    @mock.destroy
    flash[:notice] = "Mock deleted."
    redirect_to project_path(project)
  end
end
