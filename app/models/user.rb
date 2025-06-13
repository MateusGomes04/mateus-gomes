class User < ApplicationRecord
  belongs_to :company

  scope :by_company, ->(company_id) { company_id.present? ? where(company_id: company_id) : all }
  scope :by_username, ->(username) { username.present? ? where('username LIKE ?', "%#{username}%") : all }
  scope :by_display_name, ->(display_name) { display_name.present? ? where('display_name LIKE ?', "%#{display_name}%") : all }
  scope :by_email, ->(email) { email.present? ? where('email LIKE ?', "%#{email}%") : all }
end