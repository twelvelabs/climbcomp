require 'test_helper'

class UserTest < ActiveSupport::TestCase

  it 'should have a valid factory' do
    assert_equal true, build(:user).valid?
  end

  it 'should require email' do
    assert_equal false, build(:user, email: '').valid?
  end

  it 'should require unique email' do
    create(:user, email: 'foo@bar.com')
    assert_equal false, build(:user, email: 'foo@bar.com').valid?
  end

end
