class CreateMockList < ActiveRecord::Migration
  def self.up
    create_table :mock_lists do |t|
      t.string  :title
      t.integer :project_id

      t.timestamps
    end

    add_index :mock_lists, [:project_id, :title], :unique => true
  end

  def self.down
    drop_table :mock_lists
  end
end
