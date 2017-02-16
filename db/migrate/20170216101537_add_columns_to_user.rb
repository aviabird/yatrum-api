class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def self.up
    add_column :users, :google, :string
    add_column :users,  :facebook, :string
    add_column :users, :display_name, :string
  end

  def self.down
    remove_column :users, :google
    remove_column :users, :facebook
    remove_column :users, :display_name
  end
end
