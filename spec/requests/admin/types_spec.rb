require "rails_helper"

RSpec.describe "Admin::Types", type: :request do
  let(:admin) { AdminUser.create!(email: "admin@test.com", password: "password") }

  describe "GET /admin/types" do
    include_examples "requires admin login" do
      let(:make_request) { get admin_types_path }
    end
  end

  describe "POST /admin/types" do
    before { sign_in admin }

    it "creates a type" do
      expect { post admin_types_path, params: { type: { name: "Fire" } } }.to change(Type, :count).by(1)
    end
  end

  describe "DELETE /admin/types/:id" do
    before { sign_in admin }

    it "destroys the type" do
      type = Type.create!(name: "Fire")
      expect { delete admin_type_path(type) }.to change(Type, :count).by(-1)
    end
  end
end
