# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :created_at, :updated_at

  has_many :places
end
