class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params[:comment])
    begin
      @comment.save!
      @feeling = Award.maybe_grant_award(@comment)
      if @feeling
        redirect_to mock_path(:id => @comment.mock, :feeling => @feeling)
      else
        redirect_to mock_path(@comment.mock)
      end
    rescue ActiveRecord::RecordInvalid => bang
      flash[:notice] = bang.message
      @mock = @comment.mock
      render :template => "/mocks/show"
      return
    end
  end

  def ajax_create
    @comment = Comment.new(params[:comment])
    @comment.save!
    @mock = @comment.mock
    log_view
    render :partial => "/mocks/child_comment",
           :locals => {:comment => @comment.parent, :child => @comment}
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to mock_path(comment.mock)
  end
end
