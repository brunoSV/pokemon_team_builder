require "rails_helper"

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /api/v1/trainers" do
    it "creates a trainer and returns a JWT" do
      post "/api/v1/trainers", params: {
        trainer: { email: "ash@test.com", password: "password", password_confirmation: "password", name: "Ash" }
      }, as: :json

      expect(response).to have_http_status(:created)
      expect(response.headers["Authorization"]).to match(/^Bearer /)
      body = JSON.parse(response.body)
      expect(body["trainer"]["email"]).to eq("ash@test.com")
    end

    it "rejects a duplicate email" do
      Trainer.create!(email: "ash@test.com", password: "password", name: "Ash")

      post "/api/v1/trainers", params: {
        trainer: { email: "ash@test.com", password: "password", password_confirmation: "password", name: "Ash" }
      }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
