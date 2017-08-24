class UsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :profile_picture, :age
end
