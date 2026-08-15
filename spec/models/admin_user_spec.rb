require "rails_helper"

RSpec.describe AdminUser, type: :model do
  describe "validations" do
    it "requires a unique email" do
      AdminUser.create!(email: "admin@test.com", password: "password")
      duplicate = AdminUser.new(email: "admin@test.com", password: "password")
      expect(duplicate).not_to be_valid
    end
  end

  it "authenticates with the correct password" do
    admin = AdminUser.create!(email: "admin@test.com", password: "password")
    expect(admin.valid_password?("password")).to be true
    expect(admin.valid_password?("wrong")).to be false
  end
end
