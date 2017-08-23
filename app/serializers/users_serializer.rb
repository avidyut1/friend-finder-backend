class UsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :profile_picture, :age
end
