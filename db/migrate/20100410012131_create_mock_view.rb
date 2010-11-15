class CreateMockView < ActiveRecord::Migration
  def self.up
    create_table :mock_views do |t|
      t.integer  :mock_id,                       :null => false
      t.integer  :user_id,                       :null => false
      t.datetime :viewed_at,                     :null => false
      t.integer  :reply_count,    :default => 0, :null => false
      t.datetime :last_replied_at
    end

    add_index :mock_views, [:mock_id, :user_id], :unique => true
    add_index :mock_views, [:user_id, :last_replied_at]
  end

  def self.down
    drop_table :mock_views
  end
end
