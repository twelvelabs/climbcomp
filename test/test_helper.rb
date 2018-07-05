ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
require 'mocha/minitest'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# Self sign JWTs in the test env
Oidc::JwtWriter.private_key = OpenSSL::PKey::RSA.generate(2048)

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Temporarily clear out the private key so we can test normal behavior
  def without_jwt_private_key
    orig_key = Oidc::JwtWriter.private_key
    Oidc::JwtWriter.private_key = nil
    yield
  ensure
    Oidc::JwtWriter.private_key = orig_key
  end

end
