class UserIdentity < ApplicationRecord

  belongs_to :user

  validates :user,  presence: true
  validates :sub,   presence: true
  validates :email, presence: true

end
