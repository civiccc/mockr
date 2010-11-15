class Comment < ActiveRecord::Base

  belongs_to :author,
    :class_name => "User"
  belongs_to :mock, :touch => true
  belongs_to :parent,
    :class_name => 'Comment'
  has_many :children,
    :class_name => 'Comment',
    :foreign_key => 'parent_id'


  named_scope :about, lambda {|mock| {:conditions => {:mock_id => mock.id}}}
  named_scope :by, lambda {|author| {:conditions => {:author_id => author.id}}}
  named_scope :happy, :conditions => {:feeling => "happy"}
  named_scope :in_reply_to, lambda {|parent_id|
    {:conditions => {:parent_id => parent_id}}
  }
  named_scope :recent, :order => "created_at DESC"
  named_scope :sad, :conditions => {:feeling => "sad"}
  named_scope :since, lambda {|time|
    {:conditions => ["created_at >= ?", time]}
  }

  validates_presence_of :text, :if => Proc.new { |comment|
      comment.parent
    }
  validates_presence_of :author
  validates_presence_of :feeling, :if => Proc.new { |comment|
      comment.parent.nil? && comment.text.blank?
    }

  def siblings
    self.parent_id ? self.parent.children : []
  end

  after_create do |comment|
    discussions = MockView.discussions_relevant_to(comment)
    discussions.each do |discussion|
      discussion.reply_count += 1
      discussion.last_replied_at = comment.created_at
      discussion.save!
    end
    if comment.recipient_emails.any?
      begin
        Notifier.deliver_new_comment(comment)
      rescue Exception => e
        # TODO: hook up hoptoad and fix it
        # Not sure why this happens.
      end
    end
  end

  def box_attribute
    if x && y && width && height
      "box=\"#{x}_#{y}_#{width}_#{height}\""
    else
      ""
    end
  end

  def self.basic_feelings
    ["happy", "sad"]
  end

  def self.advanced_feelings
     self.feelings - self.basic_feelings
  end
  
  def self.feelings
    Dir.glob("public/images/feelings/*").map do |name|
      name.split("/").last.gsub(".gif", "")
    end
  end

  # A comment is fresh if it has a new child comment or it hasn't been viewed
  # yet.
  def fresh?(mock_viewed_at)
    if !mock_viewed_at
      true
    elsif self.children.any?
      self.children.last.created_at > mock_viewed_at
    else
      self.created_at > mock_viewed_at
    end
  end

  def recipient_emails
    self.subscriber_emails - [self.author.email]
  end

  def siblings
    self.parent_id ? (self.parent.children - [self]) : []
  end

  def subscriber_emails
    if self.parent_id
      ([self.parent] + self.siblings).map(&:author).uniq.map(&:email)
    else
      [self.mock.author.email].compact
    end
  end
end
