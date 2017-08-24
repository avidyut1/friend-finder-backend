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

  private
  def fetch_params(params)
    params.permit(:id)
  end
end
