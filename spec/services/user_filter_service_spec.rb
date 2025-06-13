require 'rails_helper'

RSpec.describe UserFilterService do
  let!(:company1) { create(:company) }
  let!(:company2) { create(:company) }
  let!(:user1) { create(:user, username: "alice", display_name: "Alice Wonderland", email: "alice@example.com", company: company1) }
  let!(:user2) { create(:user, username: "bob", display_name: "Bob Builder", email: "bob@example.com", company: company2) }

  subject { described_class.new(params).call }

  context 'with no filters' do
    let(:params) { {} }
    it { is_expected.to include(user1, user2) }
  end

  context 'filter by company' do
    let(:params) { { company_id: company1.id } }
    it { is_expected.to include(user1) }
    it { is_expected.not_to include(user2) }
  end

  context 'filter by username' do
    let(:params) { { username: 'alice' } }
    it { is_expected.to include(user1) }
    it { is_expected.not_to include(user2) }
  end

  context 'filter by display_name' do
    let(:params) { { display_name: 'Alice' } }
    it { is_expected.to include(user1) }
    it { is_expected.not_to include(user2) }
  end

  context 'filter by email' do
    let(:params) { { email: 'bob@example.com' } }
    it { is_expected.to include(user2) }
    it { is_expected.not_to include(user1) }
  end

  context 'multiple filters' do
    let(:params) { { company_id: company1.id, username: 'alice' } }
    it { is_expected.to contain_exactly(user1) }
  end
end