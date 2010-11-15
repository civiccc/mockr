class Award < ActiveRecord::Base
  def self.maybe_grant_award(comment)
    author = comment.author
    total = author.comments.size
    if total % 8 == 0
      # Check available awards.
      feelings = Comment.advanced_feelings - author.awarded_feelings 
      if feelings.any?
        # Pick a random award.
        feeling = feelings.rand
        # Grant it.
        self.create!(:feeling => feeling, :user_id => author.id)
        return feeling
      end
    end
    nil
  end
end
