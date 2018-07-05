require 'test_helper'

module Oidc
  class UserInfoTest < ActiveSupport::TestCase

    let(:token) { JwtWriter.create_token(sub: 'auth0|12345') }
    let(:attributes) do
      {
        sub:             'auth0|12345',
        name:            'Rowdy Roddy Piper',
        nickname:        'r.piper',
        picture:         'https://example.com/avatar.png',
        email:           'r.piper@example.com',
        email_verified:  true
      }
    end

    test 'fetches user info from OIDC provider' do
      stub_request(:get, 'https://climbcomp.auth0.com/userinfo')
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(body: attributes.to_json, status: 200)
      info = UserInfo.from_token(token)
      assert_equal 'auth0|12345',                     info.sub
      assert_equal 'Rowdy Roddy Piper',               info.name
      assert_equal 'r.piper',                         info.nickname
      assert_equal 'https://example.com/avatar.png',  info.picture
      assert_equal 'r.piper@example.com',             info.email
      assert_equal true,                              info.email_verified
    end

    test 'raises if invalid JSON' do
      stub_request(:get, 'https://climbcomp.auth0.com/userinfo')
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(body: '{ lol.wat**%', status: 200)
      assert_raise(UserInfo::Error) { UserInfo.from_token(token) }
    end

    test 'raises if user info request unsuccessful' do
      stub_request(:get, 'https://climbcomp.auth0.com/userinfo')
        .to_return(status: 401)
      assert_raise(UserInfo::Error) { UserInfo.from_token(token) }
    end

  end
end
