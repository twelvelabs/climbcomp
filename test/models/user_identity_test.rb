require 'test_helper'

class UserIdentityTest < ActiveSupport::TestCase

  it 'should have a valid factory' do
    assert_equal true, build(:user_identity).valid?
  end

  it 'should require a user' do
    assert_equal false, build(:user_identity, user: nil).valid?
  end

  it 'should require a sub' do
    assert_equal false, build(:user_identity, sub: '').valid?
  end

  it 'should require an email address' do
    assert_equal false, build(:user_identity, email: '').valid?
  end

  it 'should find from token' do
    create(:user_identity, sub: 'auth0|12345')
    token = Oidc::JwtWriter.create_token(sub: 'auth0|12345')
    Oidc::UserInfo.expects(:from_token).never
    user_identity = UserIdentity.find_or_create_from_token(token)
    assert_equal 'auth0|12345', user_identity.sub
  end

  it 'should create from token' do
    token = Oidc::JwtWriter.create_token(sub: 'auth0|12345')
    info = Oidc::UserInfo.new(
      sub:      'auth0|12345',
      email:    'foo@bar.com',
      name:     'Foo Bar',
      picture:  '//avatar.png'
    )
    Oidc::UserInfo.expects(:from_token).with(token).returns(info)
    user_identity = UserIdentity.find_or_create_from_token(token)
    assert_equal 'auth0|12345',   user_identity.sub
    assert_equal 'foo@bar.com',   user_identity.email
    assert_instance_of User,      user_identity.user
    assert_equal 'foo@bar.com',   user_identity.user.email
    assert_equal 'Foo Bar',       user_identity.user.name
    assert_equal '//avatar.png',  user_identity.user.avatar_url
  end

  it 'link existing users when creating from token' do
    user = create(:user, email: 'foo@bar.com')
    token = Oidc::JwtWriter.create_token(sub: 'auth0|12345')
    info = Oidc::UserInfo.new(
      sub:    'auth0|12345',
      email:  'foo@bar.com'
    )
    Oidc::UserInfo.expects(:from_token).with(token).returns(info)
    user_identity = UserIdentity.find_or_create_from_token(token)
    assert_equal user, user_identity.user
  end

end
