require 'rails_helper'

RSpec.describe "Users", type: :request do

  RSpec.shared_context 'with multiple companies' do
    let!(:company_1) { create(:company) }
    let!(:company_2) { create(:company) }

    before do
      5.times { create(:user, company: company_1) }
      5.times { create(:user, company: company_2) }
    end
  end

  describe "#index" do
    let(:result) { JSON.parse(response.body) }

    context 'when fetching users by company' do
      include_context 'with multiple companies'

      it 'returns only the users for the specified company' do
        get users_path, params: { company_id: company_1.id }

        expect(response).to have_http_status(:ok)
        expect(result.size).to eq(company_1.users.size)
        expect(result.map { |u| u['id'] }).to match_array(company_1.users.pluck(:id))
      end
    end

    context 'when fetching all users' do
      include_context 'with multiple companies'

      it 'returns all the users' do
        get users_path

        expect(response).to have_http_status(:ok)
        expect(result.size).to eq(company_1.users.size + company_2.users.size)
      end
    end

    context 'when filtering by username' do
      let!(:user) { create(:user, username: 'special_user') }

      it 'returns only matching users' do
        get users_path, params: { username: 'special_user' }

        expect(response).to have_http_status(:ok)
        expect(result.size).to eq(1)
        expect(result.first['username']).to eq('special_user')
      end
    end

    context 'when filtering by display_name' do
      let!(:user) { create(:user, display_name: 'John Doe') }

      it 'returns only matching users' do
        get users_path, params: { display_name: 'John Doe' }

        expect(response).to have_http_status(:ok)
        expect(result.size).to eq(1)
        expect(result.first['display_name']).to eq('John Doe')
      end
    end

    context 'when filtering by email' do
      let!(:user) { create(:user, email: 'emailtest@example.com') }

      it 'returns only matching users' do
        get users_path, params: { email: 'emailtest@example.com' }

        expect(response).to have_http_status(:ok)
        expect(result.size).to eq(1)
        expect(result.first['email']).to eq('emailtest@example.com')
      end
    end

    context 'when filtering with multiple params' do
      include_context 'with multiple companies'

      let!(:user) { create(:user, username: 'multiuser', display_name: 'Multi User', email: 'multi@example.com', company: company_1) }

      it 'returns only matching users' do
        get users_path, params: { username: 'multiuser', display_name: 'Multi User', email: 'multi@example.com', company_id: company_1.id }
        result = JSON.parse(response.body)

        expect(result.size).to eq(1)
        expect(result.first['id']).to eq(user.id)
      end
    end
  end
end