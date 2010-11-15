class Project < ActiveRecord::Base
  has_many :mock_lists
  
  validates_presence_of :title
  validates_uniqueness_of :title

  named_scope :alphabetical, :order => "title ASC"
  named_scope :recently_updated, :order => "updated_at DESC"

  DISABLED_PROJECT_FORM_VALUE = -1
  def self.form_options
    [["New Project", ""],
     ["EXISTING PROJECTS", DISABLED_PROJECT_FORM_VALUE]] + 
     self.alphabetical.all.map{|p| [p.title, p.id]}
  end
  
  def self.active(limit = 5)
    self.recently_updated.first(limit)
  end

  def self.create_new_untitled_project!
    self.create!(:title => self.next_available_project_title)
  end

  DEFAULT_PROJECT_TITLE_PREFIX = "New Project"
  def self.next_available_project_title
    conditions = "title LIKE '#{DEFAULT_PROJECT_TITLE_PREFIX}%'"
    titles = self.all(:conditions => conditions).map(&:title)
    self.next_available_title(titles, DEFAULT_PROJECT_TITLE_PREFIX)    
  end

  DEFAULT_MOCK_LIST_TITLE_PREFIX = "Untitled"
  def default_mock_list_title
    conditions = "title LIKE '#{DEFAULT_MOCK_LIST_TITLE_PREFIX}%'"
    titles = self.mock_lists.all(:conditions => conditions).map(&:title)
    self.class.next_available_title(titles, DEFAULT_MOCK_LIST_TITLE_PREFIX)
  end
  
  def self.next_available_title(titles, prefix)
    available_version = titles.size + 1
    1.upto(titles.size + 1) do |i|
      if !titles.include?("#{prefix} #{i}")
        available_version = i
        break
      end
    end
    "#{prefix} #{available_version}"    
  end
end
