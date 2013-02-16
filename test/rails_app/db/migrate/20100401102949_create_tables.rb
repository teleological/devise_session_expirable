
class CreateTables < ActiveRecord::Migration

  def self.up
    create_table :users do |t|
      t.string :username
      t.string :facebook_token

      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Rememberable
      t.datetime :remember_created_at

      ## Token authenticatable
      t.string :authentication_token

      t.timestamps
    end

    create_table :admins do |t|
      ## Database authenticatable
      t.string :email,              :null => true
      t.string :encrypted_password, :null => true

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Attribute for testing route blocks
      t.boolean :active, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :admins
  end

end

