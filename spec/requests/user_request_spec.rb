require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:company) { create(:company) }

  describe "GET /users" do
    it "returns all users" do
      create_list(:user, 3, company: company)
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /companies/:company_id/users_list" do
    it "returns the list of users for a given company" do
      get company_users_list_path(company)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/new" do
    it "renders the new user form" do
      get new_user_path(company_id: company.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    context "with valid data" do
      it "creates a new user and redirects to the users list" do
        valid_params = {
          user: {
            username: "mateus_dev",
            display_name: "Mateus",
            email: "mateus@example.com",
            password: "123456",
            password_confirmation: "123456",
            company_id: company.id
          }
        }

        post users_path, params: valid_params

        expect(response).to redirect_to(company_users_list_path(company.id))
      end
    end

    context "with invalid data" do
      it "renders the form again" do
        invalid_params = {
          user: {
            username: "",
            email: "invalid",
            password: "123",
            password_confirmation: "456",
            company_id: company.id
          }
        }

        post users_path, params: invalid_params
        expect(response.body).to include("form")
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /users/confirm" do
    it "confirms the account with a valid token" do
      user = create(:user, confirmed: false)
      user.update!(confirmation_token: "validtoken")

      get confirm_users_path(token: "validtoken")

      user.reload
      expect(user.confirmed?).to be true
      expect(response).to redirect_to(confirmation_success_path)
    end

    it "does not confirm the account with an invalid token" do
      get confirm_users_path(token: "invalid")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /users/confirmation_success" do
    it "renders the confirmation success page" do
      get confirmation_success_path
      expect(response).to have_http_status(:success)
    end
  end
end
