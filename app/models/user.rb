class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_secure_password
end
