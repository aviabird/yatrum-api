class AddUniqueToUserEmail < ActiveRecord::Migration[5.0]
  def change
    def self.up
      change_column :users, :email, :string, unique: true
    end
    
    def self.down
      change_column :users, :email, :string, unique: false
    end
  end
end
