class AddSettingsPageColumnsToUser < ActiveRecord::Migration[5.0]
  def self.up
    add_column :users, :facebook_url,  :string
    add_column :users, :twitter_url,   :string
    add_column :users, :instagram_url, :string
    add_column :users, :website_url,   :string
    add_column :users, :blog_url,      :string
  end

  def self.down
    remove_column :users, :facebook_url,  :string
    remove_column :users, :twitter_url,   :string
    remove_column :users, :instagram_url, :string
    remove_column :users, :website_url,   :string
    remove_column :users, :blog_url,      :string
  end
end
