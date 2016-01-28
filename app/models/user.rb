class User < ActiveRecord::Base
  has_many :matches
  has_many :requests

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true

end