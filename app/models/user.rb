class User < ApplicationRecord
  belongs_to :company
  has_many :tweets, dependent: :destroy
  before_create :generate_confirmation_token
  after_create :send_confirmation_email, if: -> { !confirmed? }
  has_secure_password

  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  scope :by_company, ->(company_id) { company_id.present? ? where(company_id: company_id) : all }
  scope :by_username, ->(username) { username.present? ? where('username LIKE ?', "%#{username}%") : all }
  scope :by_display_name, ->(display_name) { display_name.present? ? where('display_name LIKE ?', "%#{display_name}%") : all }
  scope :by_email, ->(email) { email.present? ? where('email LIKE ?', "%#{email}%") : all }
  scope :confirmed, -> { where(confirmed: true) }

  def self.find_by_username(username)
    find_by(username: username)
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end

  def send_confirmation_email
    UserMailer.with(user: self).confirmation_email.deliver_now
  end
end