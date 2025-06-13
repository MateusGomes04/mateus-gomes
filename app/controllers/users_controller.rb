class UsersController < ApplicationController
  def index
    users = UserFilterService.new(search_params).call
    render json: users
  end

  private

  def search_params
    params.permit(:company_id, :username, :display_name, :email)
  end
end
