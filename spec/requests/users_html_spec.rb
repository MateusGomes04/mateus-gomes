require 'rails_helper'

RSpec.describe "Users HTML", type: :request do
  describe "GET /signup" do
    it "renders the new user form" do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cadastro de Usuário")
    end
  end

  describe "POST /signup" do
    let!(:company) { create(:company) }

    it "creates a new user and redirects to root" do
      post signup_path, params: {
        user: {
          username: "test_user",
          display_name: "Test User",
          email: "test@example.com",
          password: "password",
          password_confirmation: "password",
          company_id: company.id
        }
      }

      expect(response).to redirect_to(root_path)
    end

    it "renders new again when validation fails" do
      post signup_path, params: {
        user: {
          username: "",
          email: "invalid",
          password: "123",
          password_confirmation: "456"
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cadastro de Usuário")
    end
  end

  describe "GET /users/confirm" do
    let!(:user) { create(:user, confirmed: false) }

    before do
      user.update(confirmation_token: "abc123")
    end

    context "with valid token" do
      it "confirms the user and redirects to confirmation success" do
        get confirm_users_path(token: "abc123")
        user.reload
        expect(response).to redirect_to(confirmation_success_path)

        expect(user.confirmed).to be true
        expect(user.confirmation_token).to be_nil
      end
    end

    context "with invalid token" do
      it "redirects to root with alert" do
        get confirm_users_path(token: "invalidtoken")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /users/confirmation_success" do
    it "renders the confirmation success page" do
      get confirmation_success_path
      expect(response).to have_http_status(:ok)
    end
  end
end
