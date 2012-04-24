class Comment < ActiveRecord::Base

  MAX_COMMENT_LENGTH = 2_000
  belongs_to :author,
    :class_name => "User"
  belongs_to :mock, :touch => true
  belongs_to :parent,
    :class_name => 'Comment'
  has_many :children,
    :class_name => 'Comment',
    :foreign_key => 'parent_id'


  scope :about, lambda {|mock| {:conditions => {:mock_id => mock.id}}}
  scope :by, lambda {|author| {:conditions => {:author_id => author.id}}}
  scope :happy, :conditions => {:feeling => "happy"}
  scope :in_reply_to, lambda {|parent_id|
    {:conditions => {:parent_id => parent_id}}
  }
  scope :recent, :order => "created_at DESC"
  scope :sad, :conditions => {:feeling => "sad"}
  scope :since, lambda {|time|
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

  before_validation :truncate_text_if_necessary

  def truncate_text_if_necessary
    self.text = self.text[0, MAX_COMMENT_LENGTH]
  end

  after_create do |comment|
    discussions = MockView.discussions_relevant_to(comment)
    discussions.each do |discussion|
      discussion.reply_count += 1
      discussion.last_replied_at = comment.created_at
      discussion.save!
    end
    if comment.recipient_emails.any?
      MockMailer.new_comment(comment).deliver
    end
  end

  def box_coords
    coords = [x, y, width, height]
    coords if coords.all?
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
