require 'test_helper'

module Oidc
  class JwtWriterTest < ActiveSupport::TestCase

    test 'can generate public key' do
      assert_equal JwtWriter.public_key.to_s, JwtWriter.private_key.public_key.to_s
    end

    test 'public_key returns nil when no private key' do
      without_jwt_private_key do
        assert_nil JwtWriter.public_key
      end
    end

    test 'can create self-signed tokens' do
      claims        = { sub: 'climbcomp', foo: 'bar' }
      encoded_token = JwtWriter.create_token(claims).to_s
      decoded_token = JSON::JWT.decode(encoded_token, JwtWriter.public_key)
      assert_equal 'climbcomp', decoded_token[:sub]
      assert_equal 'bar',       decoded_token[:foo]
    end

    test 'create_token raises when no private key' do
      without_jwt_private_key do
        assert_raise(StandardError) { JwtWriter.create_token(foo: 'bar') }
      end
    end

  end
end
