class User < ApplicationRecord

  has_many :identities, class_name: 'UserIdentity'

  validates :email, presence: true,
                    uniqueness: true

end
