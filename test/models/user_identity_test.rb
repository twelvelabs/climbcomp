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

end
