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

class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :review, :created_at, :updated_at

  has_many :pictures
end
