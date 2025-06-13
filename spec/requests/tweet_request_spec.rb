require 'rails_helper'

RSpec.describe TweetsController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user, username: 'user_5_5') }
    let!(:user_tweet) { create(:tweet, user: user, created_at: 1.day.ago) }
    let!(:other_tweet) { create(:tweet, created_at: 2.days.ago) }

    context 'when params[:user_username] is present' do
      it 'returns only tweets for the given user' do
        get :index, params: { user_username: user.username }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.count).to eq(1)
        expect(json_response.first['user_id']).to eq(user.id)
      end

      it 'returns error if user does not exist' do
        get :index, params: { user_username: 'non_existing_user' }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end

      it 'returns message if user has no tweets' do
        user_without_tweets = create(:user, username: 'no_tweets_user')

        get :index, params: { user_username: user_without_tweets.username }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User has no tweets')
      end
    end

    context 'when params[:user_username] is not present' do
      it 'returns all tweets ordered by created_at descending' do
        get :index

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.size).to eq(Tweet.count)
        expect(json_response.first['created_at']).to be >= json_response.last['created_at']
      end
    end
  end
end
