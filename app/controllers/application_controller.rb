class ApplicationController < ActionController::API

  before_action :require_authentication

  def current_token
    @current_token ||= Oidc::JwtReader.new(request).token
  end

  private

  def require_authentication
    return render_unauthorized unless current_token
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Bearer realm="climbcomp"'
    render plain: "Invalid token\n", status: :unauthorized
  end

end
