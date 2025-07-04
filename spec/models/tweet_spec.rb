require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'scopes' do
    describe '.recent' do
      it 'returns tweets ordered by created_at descending' do
        older_tweet = create(:tweet, created_at: 2.days.ago)
        newer_tweet = create(:tweet, created_at: 1.day.ago)

        expect(Tweet.recent.first).to eq(newer_tweet)
        expect(Tweet.recent.last).to eq(older_tweet)
      end
    end

    describe '.by_user' do
      it 'returns tweets only from the specified user' do
        user = create(:user)
        other_user = create(:user)

        user_tweet = create(:tweet, user: user)
        other_tweet = create(:tweet, user: other_user)

        expect(Tweet.by_user(user.id)).to include(user_tweet)
        expect(Tweet.by_user(user.id)).not_to include(other_tweet)
      end

      it 'returns all tweets if user_id is nil' do
        tweets = create_list(:tweet, 3)
        expect(Tweet.by_user(nil).count).to eq(3)
      end

      it 'returns all tweets if user_id is empty string' do
        tweets = create_list(:tweet, 2)
        expect(Tweet.by_user('').count).to eq(2)
      end
    end
  end
end