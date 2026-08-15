require "rails_helper"

RSpec.describe "Admin::Attacks", type: :request do
  let(:admin) { AdminUser.create!(email: "admin@test.com", password: "password") }

  describe "GET /admin/attacks" do
    include_examples "requires admin login" do
      let(:make_request) { get admin_attacks_path }
    end
  end

  describe "POST /admin/attacks" do
    before { sign_in admin }

    it "creates an attack" do
      expect { post admin_attacks_path, params: { attack: { name: "Tackle" } } }.to change(Attack, :count).by(1)
    end
  end
end
