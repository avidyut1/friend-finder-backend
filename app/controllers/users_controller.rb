class UsersController < ApplicationController

  def fetch
    id = fetch_params(params)[:id]
    #TODO get user from jwt
    user = User.find_by_id(id)
    if user
      sql = 'select * from users where id not in
          (select second_user_id from likes where first_user_id = ?
           union all select second_user_id from dislikes where first_user_id = ?
           union all select ?)
          and sex <> ? limit 50;'
      users = User.find_by_sql([sql, id, id, id, user.sex])
      render json: users, each_serializer: UsersSerializer
    else
      render json: {message: 'no_user_found'}
    end
  end

  def sign_up
    sign_up_params = sign_up_params(params)
    u = User.new
    u.avatar = sign_up_params[:avatar]
    u.name = sign_up_params[:name]
    u.age = sign_up_params[:age]
    u.sex = sign_up_params[:sex]
    u.email = sign_up_params[:email]
    u.password = sign_up_params[:password]
    if sign_up_params[:password].nil?
      render json: {message: 'sign_up failed', reason: 'missing data'}
      return
    end
    if u.save
      jwt = generate_jwt(u)
      render json: {token: jwt, name: u.name, age: u.age, avatar: u.avatar.url, sex: u.sex, email: u.email}
    else
      render json: {message: 'sign_up failed'}
    end
  end

  def login
    login_params = login_params(params)
    email = login_params[:email]
    password = login_params[:password]
    u = User.find_by_email(email)
    if u && u.authenticate(password)
      jwt = generate_jwt(u)
      render json: {token: jwt, name: u.name, age: u.age, avatar: u.avatar.url, sex: u.sex, email: u.email}
    else
      render json: {message: 'login failed'};
    end
  end

  private
  def generate_jwt(u)
    data = u.as_json
    data.delete('password_digest')
    exp = Time.now.to_i + 3600 * 24 * 365
    exp_payload = { :data => data, :exp => exp }
    puts Figaro.env.hmac_secret
    JWT.encode exp_payload, Figaro.env.hmac_secret, 'HS256'
  end

  def fetch_params(params)
    params.permit(:id)
  end

  def sign_up_params(params)
    params.permit(:name, :age, :sex, :avatar, :email, :password)
  end

  def login_params(params)
    params.permit(:email, :password)
  end
end
