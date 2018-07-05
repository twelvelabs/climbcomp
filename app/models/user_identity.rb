class UserIdentity < ApplicationRecord

  belongs_to :user

  validates :user,  presence: true
  validates :sub,   presence: true
  validates :email, presence: true

  class << self
    def create_from_token(token)
      info = Oidc::UserInfo.from_token(token)
      user = User.where(email: info.email).first_or_create(
        name:       info.name,
        avatar_url: info.picture
      )
      user.identities.create(info.serializable_hash.compact)
    end

    def find_or_create_from_token(token)
      where(sub: token[:sub]).first || create_from_token(token)
    end
  end

end
