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

class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :review, :visited_date, :created_at, :updated_at

  has_many :pictures
end
