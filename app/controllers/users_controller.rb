class UsersController < ApplicationController

  def fetch
    id = fetch_params(params)[:id]
    sql = 'select * from users where id not in
          (select second_user_id from likes where first_user_id = ?
           union all select second_user_id from dislikes where first_user_id = ?
           union all select ?) limit 50;'
    users = User.find_by_sql([sql, id, id, id])
    render json: users
  end

  private
  def fetch_params(params)
    params.permit(:id)
  end
end
