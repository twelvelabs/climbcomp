module Oidc
  class JwtReader

    HTTP_HEADER_REGEX = /^Bearer\s+(.+)$/

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def token
      return nil unless token_string.present?
      token = JSON::JWT.decode(token_string, jwks)
      # TODO: validate `iss` and `aud`
      return nil unless token[:sub].present?
      return nil if token[:exp] && (Time.at(token[:exp]) < Time.now)
      token
    rescue JSON::JWT::InvalidFormat, JSON::JWT::VerificationFailed
      nil
    end

    def token_string
      match = request.headers['Authorization'].to_s.match(HTTP_HEADER_REGEX)
      match && match[1]
    end

    def jwks
      # `JwtWriter.public_key` will only be present in the test env (where we're using self-signed tokens).
      # All the other envs will fetch keys from `ENV['JWKS_URL']`.
      keys = JwtWriter.public_key ? [JwtWriter.public_key] : jwks_json
      @jwks ||= JSON::JWK::Set.new(keys)
    end

    private

    def jwks_json
      JSON.parse(jwks_url_response)
    rescue JSON::ParserError
      nil
    end

    def jwks_url_response
      Rails.cache.fetch('jwks_url_response', expires_in: 5.minutes) do
        Net::HTTP.get(URI.parse(ENV['JWKS_URL']))
      end
    end

  end
end
