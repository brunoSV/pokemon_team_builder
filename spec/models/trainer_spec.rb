require "rails_helper"

RSpec.describe Trainer, type: :model do
  describe "validations" do
    it "requires a unique email" do
      Trainer.create!(email: "ash@test.com", password: "password", name: "Ash")
      duplicate = Trainer.new(email: "ash@test.com", password: "password", name: "Someone else")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "orders team_memberships by slot" do
      trainer = Trainer.create!(email: "ash@test.com", password: "password", name: "Ash")
      pikachu = Pokemon.create!(name: "Pikachu", national_dex_number: 25, generation: 1, image_url: "x")
      eevee = Pokemon.create!(name: "Eevee", national_dex_number: 133, generation: 1, image_url: "x")
      TeamMembership.create!(trainer: trainer, pokemon: eevee, slot: 2)
      TeamMembership.create!(trainer: trainer, pokemon: pikachu, slot: 1)

      expect(trainer.team_memberships.map(&:slot)).to eq([ 1, 2 ])
    end
  end

  describe "jti (devise-jwt)" do
    it "is assigned automatically on create" do
      trainer = Trainer.create!(email: "ash@test.com", password: "password", name: "Ash")
      expect(trainer.jti).to be_present
    end
  end
end
