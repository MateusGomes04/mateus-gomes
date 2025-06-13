class TweetsController < ApplicationController
  def index
    if params[:user_username].present?
      user = User.find_by_username(params[:user_username])
      return render(json: { error: "User not found" }, status: :not_found) unless user

      tweets = Tweet.by_user(user.id).recent
      return render(json: { message: "User has no tweets" }) if tweets.empty?
    else
      tweets = Tweet.recent
    end

    render json: tweets
  end
end