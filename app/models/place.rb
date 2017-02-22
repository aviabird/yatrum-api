# == Schema Information
#
# Table name: places
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :string
#  review       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  trip_id      :integer
#  visited_date :datetime
#

class Place < ApplicationRecord
  has_many :pictures
  belongs_to :trip, required: false # http://stackoverflow.com/a/39584972/1930053

  accepts_nested_attributes_for :pictures, :allow_destroy => true

  def place_pictures
    pictures
  end

end
