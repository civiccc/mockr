class AddDesignerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :designer, :boolean
  end

  def self.down
    remove_column :users, :designer
  end
end
