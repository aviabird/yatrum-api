# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  review      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city_id     :integer
#

class Place < ApplicationRecord
  has_many :pictures
  belongs_to :city, required: false # http://stackoverflow.com/a/39584972/1930053

  accepts_nested_attributes_for :pictures

end
