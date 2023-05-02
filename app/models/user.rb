class User < ApplicationRecord
  has_secure_password
  has_many :reservations
  has_many :cars

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
