class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price
  has_many :images
  
  
  # attributes :price do |object|
  #   object.price
  # end
end
