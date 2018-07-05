module Oidc
  class UserInfo
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON

    class Error < StandardError
    end

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
