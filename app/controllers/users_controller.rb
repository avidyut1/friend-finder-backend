class UsersController < ApplicationController

  def fetch
    user = get_user_from_token
    if user
      id = user['id']
      sql = 'select * from users where id not in
          (select second_user_id from likes where first_user_id = ?
           union all select second_user_id from dislikes where first_user_id = ?
           union all select ?)
          and sex <> ? limit 50;'
      users = User.find_by_sql([sql, id, id, id, user['sex']])
      render json: users, each_serializer: UsersSerializer
    else
      render json: {message: 'no_user_found'}
    end
  end

  def index
    user = get_user_from_token
    render json: user
  end

  def sign_up
    sign_up_params = sign_up_params(params)
    u = User.new
    u.name = sign_up_params[:name]
    u.age = sign_up_params[:age]
    u.sex = sign_up_params[:sex]
    u.email = sign_up_params[:email]
    u.password = sign_up_params[:password]
    if sign_up_params[:password].nil? || sign_up_params[:name].nil? || sign_up_params[:age].nil? || sign_up_params[:sex].nil? || sign_up_params[:email].nil?
      render json: {message: 'sign_up failed', reason: 'missing required values'}
      return
    end
    prev_user = User.find_by_email(sign_up_params[:email])
    if prev_user
      render json: {message: 'sign_up failed', reason: 'email already registered'}
      return
    end
    if u.save
      puts u.avatar_url
      jwt = generate_jwt(u)
      render json: {message: 'success', id: u.id}
    else
      render json: {message: 'sign_up failed'}
    end
  end

  def get
    u = User.find_by_id(params[:id])
    render json: u
  end

  def batch
    batch_params = batch_params(params)
    likes = batch_params[:likes]
    dislikes = batch_params[:dislikes]
    user = get_user_from_token
    if user
      save_likes(likes, user)
      save_dislikes(dislikes, user)
      render json: {message: 'success'}
    else
      render json: {message: 'no_user_found'}
    end
  end

  def login
    login_params = login_params(params)
    email = login_params[:email]
    password = login_params[:password]
    u = User.find_by_email(email)
    if u && u.authenticate(password)
      jwt = generate_jwt(u)
      render json: {message: 'success', token: jwt, id: u.id, name: u.name, age: u.age, avatar: u.avatar.url, sex: u.sex, email: u.email}
    else
      render json: {message: 'login failed'};
    end
  end

  def upload_avatar
    u = User.find_by_id(params[:id])
    if u
      u.avatar = params[:file]
      if u.save
        render json: {message: 'success', url: u.avatar.url}
      else
        render json: {message: 'error saving file'}
      end
    else
      render json: {message: 'user with id does not exists'}
    end
  end

  private

  def save_likes(likes, user)
    likes.each do |like_id|
      like = Like.new
      like.first_user_id = user['id']
      like.second_user_id = like_id
      like.save
      #creating match if its a match
      reverse_like = Like.where(:first_user_id => like_id, :second_user_id => user['id']).first
      if reverse_like
        match = Match.new
        match.first_user_id = like_id
        match.second_user_id = user['id']
        match.save
        reverse_match = Match.new
        reverse_match.first_user_id = user['id']
        reverse_match.second_user_id = like_id
        reverse_match.save
      end
    end
  end

  def save_dislikes(dislikes, user)
    dislikes.each do |dislike_id|
      dislike = Dislike.new
      dislike.first_user_id = user['id']
      dislike.second_user_id = dislike_id
      dislike.save
    end
  end

  def generate_jwt(u)
    data = u.as_json
    data.delete('password_digest')
    exp = Time.now.to_i + 3600 * 24 * 365
    exp_payload = { :data => data, :exp => exp }
    JWT.encode exp_payload, Figaro.env.hmac_secret, 'HS256'
  end

  def fetch_params(params)
    params.permit(:id)
  end

  def sign_up_params(params)
    params.permit(:name, :age, :sex, :email, :password)
  end

  def login_params(params)
    params.permit(:email, :password)
  end

  def batch_params(params)
    params.permit(:likes => [], :dislikes => [])
  end

end
