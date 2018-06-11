require 'test_helper'

class RootControllerTest < ActionDispatch::IntegrationTest

  test 'index renders empty object' do
    get root_url
    assert_response :success
    assert_equal('{}', @response.body)
  end

end
