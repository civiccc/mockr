class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.integer :user_id
      t.string  :feeling

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
