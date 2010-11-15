class MockView < ActiveRecord::Base
  belongs_to :mock

  def self.log_view(mock, user)
    mock_view =
      self.first(:conditions => {:mock_id => mock.id, :user_id => user.id})
    if mock_view
      mock_view.update_attributes(:reply_count => 0, :viewed_at => Time.now)
    else
      self.create! :mock_id => mock.id, 
                   :user_id => user.id, 
                   :viewed_at => Time.now
    end
  end
  
  def self.last_viewed_at(mock, user)
    mock_view =
      self.first(:conditions => {:mock_id => mock.id, :user_id => user.id})
    mock_view ? mock_view.viewed_at : nil
  end
  
  def self.discussions_relevant_to(comment)
    return [] unless comment.parent_id
    related_comments = [comment.parent] + comment.siblings
    author_ids = related_comments.map(&:author_id).uniq
    conditions = {:user_id => author_ids, :mock_id => comment.mock_id}
    self.all(:conditions => conditions)
  end
end
