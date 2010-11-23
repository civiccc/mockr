class RaiseCommentLength < ActiveRecord::Migration
  def self.up
    change_column :comments, :text, :string, :limit => 2000
  end

  def self.down
    change_column :comments, :text, :string, :limit => 255
  end
end
