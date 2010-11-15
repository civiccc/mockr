class CreateMock < ActiveRecord::Migration
  def self.up
    create_table :mocks do |t|
      t.string   :path, :null => false
      t.string   :title
      t.string   :description, :limit => 2000
      t.integer  :mock_list_id
      t.integer  :version
      t.integer  :author_id
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end

    add_index "mocks", ["mock_list_id"]
  end

  def self.down
    drop_table :mocks
  end
end
