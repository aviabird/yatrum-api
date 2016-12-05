class PictureSerializer < ActiveModel::Serializer
  attributes :id, :url, :description, :created_at, :updated_at
end
