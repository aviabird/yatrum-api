module Common
  def cusotm_serializer(collection, serializer)
    ActiveModel::Serializer::CollectionSerializer.new(collection, each_serializer: serializer)
  end
end