class CreateProject < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
