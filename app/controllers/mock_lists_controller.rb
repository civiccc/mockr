class MockListsController < ApplicationController
  def update
    @mock_list = MockList.find(params[:id])
    @mock_list.update_attributes(params[:mock_list])
    if params[:inline].to_i == 1
      render :text => params[:mock_list].values.first
    else
      redirect_to project_path(@mock_list.project_id)
    end
  end
end
