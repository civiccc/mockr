class RemoveUniqueConstraintFromTitlesOnMockLists < ActiveRecord::Migration
  def self.up
    remove_index :mock_lists, [:project_id, :title]
    add_index :mock_lists, [:project_id, :title]
  end

  def self.down
    remove_index :mock_lists, [:project_id, :title]
    add_index :mock_lists, [:project_id, :title], :unique => true
  end
end
