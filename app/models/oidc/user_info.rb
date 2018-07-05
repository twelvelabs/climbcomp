module Oidc
  class UserInfo
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Serializers::JSON

    class Error < StandardError
    end

    attribute :sub,             :string
    attribute :name,            :string
    attribute :nickname,        :string
    attribute :picture,         :string
    attribute :email,           :string
    attribute :email_verified,  :boolean, default: false

    attr_accessor :sub, :name, :nickname, :picture, :email, :email_verified

    class << self
      def from_token(token)
        r = Faraday.get('https://climbcomp.auth0.com/userinfo', nil, authorization: "Bearer #{token}")
        raise Error, "Unsuccessful request: #{r.status}" unless r.success?
        new.from_json(r.body)
      rescue JSON::ParserError
        raise Error, 'Invalid JSON'
      end
    end

  end
end
