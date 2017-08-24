class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_secure_password
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :age
  validates_presence_of :sex
end
