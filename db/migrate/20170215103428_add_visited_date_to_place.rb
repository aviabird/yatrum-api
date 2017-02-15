class AddVisitedDateToPlace < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :visited_date, :datetime
  end
end
