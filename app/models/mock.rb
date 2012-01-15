class Mock < ActiveRecord::Base
  DISPLAY_LIMIT = 18
  
  belongs_to :author, :class_name => "User"
  belongs_to :mock_list

  has_many :comments, :order => "created_at DESC"

  named_scope :offset, lambda {|offset| {:offset => offset}}
  named_scope :recent, lambda {|limit| {:order => "id DESC", :limit => limit}}
  named_scope :with_author_and_project_data,
              :include => [:author, {:mock_list => :project}]

  has_attached_file :image,
    PAPERCLIP_STORAGE_OPTIONS.merge(
      :styles => {
        :thumb  => "150x150#" # 150x150 thumbnail
      }
    )

  validates_presence_of :author, :image_file_name, :mock_list, :version

  before_validation do |mock|
    mock.assign_version if mock.version.nil?
  end

  before_destroy do |mock|
    mock.update_future_versions_of_destruction
  end

  def self.hosted_by_aws?
    File.exists?(AWS_W3_CONFIG_FILE)
  end
  
  def self.total_pages
    self.count > 0 ? (self.count.to_f / DISPLAY_LIMIT).ceil : 0
  end

  def attachment_body
    if self.class.hosted_by_aws?
      Net::HTTP.get_response(URI.parse(self.image.url)).body
    else
      File.read(self.image.path)
    end
  end

  def attach_mock_list_if_necessary!(project_id, title)
    if !self.mock_list_id
      project = Project.find(project_id)
      ml = project.mock_lists.create(:title => 
        title || project.default_mock_list_title)
      self.mock_list_id = ml.id
    end
  end

  def assign_version
    self.version = self.inferred_version
  end

  def inferred_version
    version = if self.mock_list
      previous_iterations_count = self.mock_list.mocks.size
      previous_iterations_count + 1
    else
      1
    end
    puts "Assigning version #{version} to mock #{self.id}"
    version
  end

  def project
    self.mock_list.project
  end
  
  def title=(title)
    mock_list = self.mock_list
    mock_list.update_attribute(:title, title) if mock_list
  end

  def title
    self.mock_list ? "#{self.mock_list.title} #{self.version}" : ""
  end

  def default_subject
    self.title
  end

  def filtered_comments(filter, user)
    conditions = {:mock_id => self.id, :parent_id => nil}
    if filter.to_i > 0
      conditions.merge!(:author_id => filter.to_i)
    elsif filter
      conditions.merge!(:feeling => filter)
    end
    Comment.all(:conditions => conditions)
  end

  def next
    self.class.first(:conditions => {
      :mock_list_id => self.mock_list_id,
      :version => self.version + 1
    })
  end

  def prev
    self.class.first(:conditions => {
      :mock_list_id => self.mock_list_id,
      :version => self.version - 1
    })
  end

  def happy_count
    Comment.happy.about(self).count
  end

  def sad_count
    Comment.sad.about(self).count
  end

  # A mock is "fresh" if there are new comments since the user last viewed.
  def fresh?(user)
    if user.real?
      last_viewed_at = MockView.last_viewed_at(self, user)
      !last_viewed_at || (self.updated_at > last_viewed_at)
    else
      false
    end
  end

  def deliver(email)
    Notifier.deliver_new_mock(self, email)
  end

  # TODO [chris]: Does acts_as_list cover this?
  def update_future_versions_of_destruction
    conditions =
      "mock_list_id = #{self.mock_list_id} AND version > #{self.version}"
    future_mocks = self.class.all(:conditions => conditions)
    future_mocks.each do |mock|
      mock.update_attribute(:version, mock.version - 1)
    end
  end
end
