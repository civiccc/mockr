class ProjectsController < ApplicationController
  def new
  end

  def create
    begin
      @project = Project.new(params[:project])
      @project.save!
      flash[:notice] = "Project created!"
      redirect_to project_path(@project)
    rescue ActiveRecord::RecordInvalid
      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    if params[:inline].to_i == 1
      render :text => params[:project].values.first
    else
      redirect_to project_path(project)
    end
  end

  def show
    @project = Project.find(params[:id])
  end
end