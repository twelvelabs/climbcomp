require 'test_helper'

class JwtReaderTest < ActiveSupport::TestCase

  test 'jwks returns local JWK when private key' do
    reader = JwtReader.new(nil)
    public_thumbprint = JwtWriter.public_key.to_jwk.thumbprint
    assert_equal(public_thumbprint, reader.jwks[0].thumbprint)
  end

  test 'jwks fetches remote JWKs when private key missing' do
    without_jwt_private_key do
      reader = JwtReader.new(nil)
      reader.expects(:jwks_url_response).returns(file_fixture('jwks.json').read)
      assert_equal('Q0I2NkYxQzk0NDVBRDQ2OEJBOUQ1RTQxNjRBNEM2RTEzQUVGQkI5QQ', reader.jwks[0][:kid])
    end
  end

  test 'valid tokens can be parsed' do
    token         = JwtWriter.create_token(foo: 'bar')
    token_string  = token.to_s
    request       = stub(headers: { 'Authorization' => "Bearer #{token_string}" })
    reader        = JwtReader.new(request)
    assert_equal token_string,  reader.token_string
    assert_equal token,         reader.token
    assert_equal 'bar',         reader.token[:foo]
  end

  test 'token is nil if expired' do
    token         = JwtWriter.create_token(foo: 'bar', exp: 1.day.ago)
    token_string  = token.to_s
    request       = stub(headers: { 'Authorization' => "Bearer #{token_string}" })
    reader        = JwtReader.new(request)
    assert_equal token_string, reader.token_string
    assert_nil reader.token
  end

  test 'token is nil if invalid token' do
    token_string  = 'this.is.garbage'
    request       = stub(headers: { 'Authorization' => "Bearer #{token_string}" })
    reader        = JwtReader.new(request)
    assert_equal token_string, reader.token_string
    assert_nil reader.token
  end

  test 'token is nil if invalid auth type' do
    request = stub(headers: { 'Authorization' => 'Basic aHR0cHdhdGNoOmY=' })
    reader  = JwtReader.new(request)
    assert_nil reader.token_string
    assert_nil reader.token
  end

  test 'token is nil if missing auth header' do
    request = stub(headers: {})
    reader  = JwtReader.new(request)
    assert_nil reader.token_string
    assert_nil reader.token
  end

end
