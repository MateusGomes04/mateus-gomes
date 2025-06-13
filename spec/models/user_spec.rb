require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:company1) { create(:company) }
  let!(:company2) { create(:company) }
  let!(:user1) { create(:user, username: "alice", display_name: "Alice Wonderland", email: "alice@example.com", company: company1) }
  let!(:user2) { create(:user, username: "bob", display_name: "Bob Builder", email: "bob@example.com", company: company2) }

  describe 'scopes' do
    it 'filters by company' do
      expect(User.by_company(company1.id)).to include(user1)
      expect(User.by_company(company1.id)).not_to include(user2)
    end

    it 'returns all if company_id blank' do
      expect(User.by_company(nil)).to include(user1, user2)
    end

    it 'filters by username' do
      expect(User.by_username("alice")).to include(user1)
      expect(User.by_username("alice")).not_to include(user2)
    end

    it 'filters by display_name' do
      expect(User.by_display_name("Alice")).to include(user1)
      expect(User.by_display_name("Alice")).not_to include(user2)
    end

    it 'filters by email' do
      expect(User.by_email("example.com")).to include(user1, user2)
      expect(User.by_email("alice@example.com")).to include(user1)
      expect(User.by_email("alice@example.com")).not_to include(user2)
    end

    it 'returns all if param blank' do
      expect(User.by_username(nil)).to include(user1, user2)
      expect(User.by_display_name(nil)).to include(user1, user2)
      expect(User.by_email(nil)).to include(user1, user2)
    end
  end
  
  describe '.find_by_username' do
    let!(:user) { create(:user, username: 'taylor') }

    it 'returns the user with the given username' do
      expect(User.find_by_username('taylor')).to eq(user)
    end

    it 'returns nil if no user with the given username exists' do
      expect(User.find_by_username('nonexistent')).to be_nil
    end
  end
end