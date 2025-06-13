class Tweet < ApplicationRecord
  belongs_to :user

  scope :by_user, ->(user_id) { user_id.present? ? where(user_id: user_id) : all }
  scope :recent, -> { order(created_at: :desc) }
end
