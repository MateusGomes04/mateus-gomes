class TweetsController < ApplicationController
  protect_from_forgery except: :index
  
  def index
    if params[:user_username].present?
      user = User.find_by_username(params[:user_username])
      return render(json: { error: "User not found" }, status: :not_found) unless user

      @company = user.company
      base_scope = user.tweets.recent
    else
      base_scope = Tweet.recent
    end

    if params[:last_id].present?
      base_scope = base_scope.where("id < ?", params[:last_id])
    end

    @tweets = base_scope.limit(20)

    respond_to do |format|
      format.html # initial render
      format.js   # AJAX load
    end
  end
end
