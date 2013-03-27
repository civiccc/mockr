class MockListsController < ApplicationController
  def latest
    @mock_list = MockList.find(params[:id])
    redirect_to mock_path(@mock_list.mocks.last)
  end

  def update
    @mock_list = MockList.find(params[:id])
    @mock_list.update_attributes(params[:mock_list])
    if params[:inline].to_i == 1
      render :text => params[:mock_list].values.first
    else
      redirect_to project_path(@mock_list.project_id)
    end
  end
  
  def destroy
    @mock_list = MockList.find(params[:id])
    @mock_list.destroy
    flash[:notice] = "Mock removed."
    redirect_to project_path(@mock_list.project)
  end
end
