class AddCountColumnToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :impressions_count, :integer, :default => 0
  end
end
