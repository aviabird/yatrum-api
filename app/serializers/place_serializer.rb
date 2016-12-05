class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :review, :created_at, :updated_at

  has_many :pictures
end
