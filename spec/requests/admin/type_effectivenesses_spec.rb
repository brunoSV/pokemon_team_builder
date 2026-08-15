require "rails_helper"

RSpec.describe "Admin::TypeEffectivenesses", type: :request do
  let(:admin) { AdminUser.create!(email: "admin@test.com", password: "password") }
  let(:fire) { Type.create!(name: "Fire") }
  let(:grass) { Type.create!(name: "Grass") }

  describe "GET /admin/type_effectivenesses" do
    include_examples "requires admin login" do
      let(:make_request) { get admin_type_effectivenesses_path }
    end
  end

  describe "POST /admin/type_effectivenesses" do
    before { sign_in admin }

    it "creates a type effectiveness entry" do
      expect {
        post admin_type_effectivenesses_path, params: {
          type_effectiveness: { attacking_type_id: fire.id, defending_type_id: grass.id, multiplier: 2 }
        }
      }.to change(TypeEffectiveness, :count).by(1)
    end
  end
end
