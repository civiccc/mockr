class MockList < ActiveRecord::Base
  belongs_to :project

  has_many :mocks, :order => "version ASC"
  
  def self.create_if_necessary!(mock_params)
    if mock_params[:mock_list_id].blank?
      MockList.create!(:title => self[:title], :project_id => self[:project_id])
    end
  end
end
