require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  before { Trainer.create!(email: "ash@test.com", password: "password", name: "Ash") }

  describe "POST /api/v1/trainers/login" do
    it "logs in with correct credentials and returns a JWT" do
      post "/api/v1/trainers/login", params: { trainer: { email: "ash@test.com", password: "password" } }, as: :json

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to match(/^Bearer /)
    end

    it "rejects incorrect credentials" do
      post "/api/v1/trainers/login", params: { trainer: { email: "ash@test.com", password: "wrong" } }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
