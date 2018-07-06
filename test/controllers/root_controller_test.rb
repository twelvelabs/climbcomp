require 'test_helper'

class RootControllerTest < ActionDispatch::IntegrationTest

  test 'unauthorized if missing auth header' do
    get root_url
    assert_response :unauthorized
    assert_equal 'Bearer realm="climbcomp"', @response.headers['WWW-Authenticate']
  end

  test 'unauthorized if invalid auth type' do
    get root_url, headers: { 'Authorization': 'Basic aHR0cHdhdGNoOmY=' }
    assert_response :unauthorized
  end

  test 'unauthorized if invalid token' do
    get root_url, headers: { 'Authorization': 'Bearer this.is.not.a.token' }
    assert_response :unauthorized
  end

  test 'index renders empty object' do
    get root_url, headers: auth_headers
    assert_response :success
    assert_equal('{}', @response.body)
  end

end
