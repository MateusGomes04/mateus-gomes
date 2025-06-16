require 'rails_helper'

RSpec.describe TweetsController, type: :request do
  let!(:user) { create(:user, username: 'user_5_5') }
  let!(:user_tweet) { create(:tweet, user: user, body: "User tweet body", created_at: 1.day.ago) }
  let!(:other_tweet) { create(:tweet, body: "Other tweet body", created_at: 2.days.ago) }

  describe 'GET /tweets' do
    context 'when user_username param is present' do
      it 'renders html with user tweets' do
        get tweets_path, params: { user_username: user.username }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("User tweet body")
        expect(response.body).not_to include("Other tweet body")
      end

      it 'returns 404 json if user not found' do
        get tweets_path, params: { user_username: 'not_exist' }, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('User not found')
      end
    end

    context 'when user_username param is not present' do
      it 'renders html with all tweets ordered desc' do
        get tweets_path

        expect(response).to have_http_status(:ok)
        expect(response.body.index("User tweet body")).to be < response.body.index("Other tweet body")
      end
    end

    context 'when format is js' do
      it 'renders the index.js.erb template' do
        get tweets_path, params: { user_username: user.username }, xhr: true, headers: { 'ACCEPT' => 'text/javascript' }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('javascript')
      end
    end
  end
end