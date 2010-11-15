class CreateUser < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :name, :null => false, :default => ""
      t.integer  :facebook_uid, :null => false
      t.string   :email
      t.boolean  :active, :default => true

      t.timestamps
    end

    case ActiveRecord::Base.connection.adapter_name
      when "MySQL"
        execute("ALTER TABLE users MODIFY COLUMN facebook_uid bigint NOT NULL");
      when "PostgreSQL"
        execute("ALTER TABLE users ALTER COLUMN facebook_uid TYPE bigint")
      else
        raise "Don't know how to change column to bigint"
    end

    add_index "users", "facebook_uid", :unique => true
  end

  def self.down
    drop_table :users
  end
end
