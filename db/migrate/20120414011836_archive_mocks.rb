class ArchiveMocks < ActiveRecord::Migration
  def self.up
    add_column :projects, :archived_at, :datetime, :null => true
  end

  def self.down
    remove_column :projects, :archived_at
  end
end
