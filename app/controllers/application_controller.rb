class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def get_user_from_token
    token = request.headers['Authorization']
    begin
      decoded_token = JWT.decode token, Figaro.env.hmac_secret, true, { :algorithm => 'HS256' }
      puts decoded_token
      decoded_token[0]['data']
    rescue JWT::ExpiredSignature
      # Handle expired token, e.g. logout user or deny access
      return nil
    end
  end
end
