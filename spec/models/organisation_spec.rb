require "rails_helper"

RSpec.describe Organisation, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:organisation_type) }
    it { should validate_presence_of(:language_code) }
    it { should validate_presence_of(:default_currency) }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:users) }
  end
end
