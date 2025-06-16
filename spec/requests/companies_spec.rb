require 'rails_helper'

RSpec.describe "Companies", type: :request do
  let!(:company) { Company.create(name: "Test Company") }

  describe "GET /companies" do
    it "returns success" do
      get companies_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Test Company")
    end
  end

  describe "GET /companies/new" do
    it "returns success" do
      get new_company_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /companies" do
    context "with valid parameters" do
      it "creates a new company and redirects" do
        expect {
          post companies_path, params: { company: { name: "New Company" } }
        }.to change(Company, :count).by(1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(companies_path)
        follow_redirect!

        expect(request.flash[:notice]).to eq("Empresa criada com sucesso.")
        expect(response.body).to include("New Company")
      end
    end

    context "with invalid parameters" do
      it "renders the new template again" do
        post companies_path, params: { company: { name: "" } }
        follow_redirect!
        expect(response).to have_http_status(:success) 
        expect(response.body).to include("<form")
      end
    end
  end

  describe "GET /companies/:id/edit" do
    it "returns success" do
      get edit_company_path(company)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(company.name)
    end
  end

  describe "PATCH /companies/:id" do
    context "with valid parameters" do
      it "updates the company and redirects" do
        patch company_path(company), params: { company: { name: "Updated Company" } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(companies_path)
        follow_redirect!

        expect(request.flash[:notice]).to eq("Empresa atualizada com sucesso.")
        expect(company.reload.name).to eq("Updated Company")
        expect(response.body).to include("Updated Company")
      end
    end

    context "with invalid parameters" do
      it "renders the edit template again" do
        patch company_path(company), params: { company: { name: "" } }
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include("<form")
      end
    end
  end

  describe "DELETE /companies/:id" do
    it "deletes the company and redirects" do
      expect {
        delete company_path(company)
      }.to change(Company, :count).by(-1)

      expect(response).to have_http_status(:found) 
      expect(response).to redirect_to(companies_path)
      follow_redirect!

      expect(request.flash[:notice]).to eq("Empresa excluída com sucesso.")
      expect(response.body).not_to include(company.name)
    end
  end
end
