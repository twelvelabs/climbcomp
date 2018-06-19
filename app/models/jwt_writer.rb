class JwtWriter

  class << self
    attr_accessor :private_key

    def public_key
      private_key && private_key.public_key
    end

    def create_token(claims = {})
      raise 'Missing private key' unless private_key
      JSON::JWT.new(claims).sign(private_key.to_jwk, :RS256)
    end
  end

end
