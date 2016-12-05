class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :created_at, :updated_at

  has_many :places
end
