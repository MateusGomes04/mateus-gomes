require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }

  describe 'validations' do
    it 'is invalid without a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid without password confirmation' do
      user = build(:user, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end

    it 'is invalid if password and confirmation do not match' do
      user = build(:user, password: '123456', password_confirmation: '654321')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'scopes' do
    it 'returns only users from the given company with .by_company' do
      other_company = create(:company)
      user1 = create(:user, company: company)
      user2 = create(:user, company: other_company)

      expect(User.by_company(company.id)).to include(user1)
      expect(User.by_company(company.id)).not_to include(user2)
    end

    it 'returns users matching username with .by_username' do
      user = create(:user, username: "mateus_dev")
      expect(User.by_username("mateus")).to include(user)
    end

    it 'returns users matching display_name with .by_display_name' do
      user = create(:user, display_name: "Mateus Gomes")
      expect(User.by_display_name("Gomes")).to include(user)
    end

    it 'returns users matching email with .by_email' do
      user = create(:user, email: "mateus@example.com")
      expect(User.by_email("mateus")).to include(user)
    end

    it 'returns only confirmed users with .confirmed' do
      confirmed_user = create(:user, confirmed: true)
      unconfirmed_user = create(:user, confirmed: false)

      expect(User.confirmed).to include(confirmed_user)
      expect(User.confirmed).not_to include(unconfirmed_user)
    end
  end

  describe '.find_by_username' do
    it 'finds user by exact username' do
      user = create(:user, username: "unique_user")
      expect(User.find_by_username("unique_user")).to eq(user)
    end
  end

  describe 'callbacks' do
    it 'generates a confirmation_token before creation' do
      user = create(:user, confirmation_token: nil)
      expect(user.confirmation_token).not_to be_nil
    end
  end

  describe 'confirmation email' do
    it 'sends confirmation email after create if not confirmed' do
      allow(UserMailer).to receive_message_chain(:with, :confirmation_email, :deliver_now)
      create(:user, confirmed: false)
      expect(UserMailer).to have_received(:with)
    end

    it 'does not send confirmation email if already confirmed' do
      allow(UserMailer).to receive(:with)
      create(:user, confirmed: true)
      expect(UserMailer).not_to have_received(:with)
    end
  end
end