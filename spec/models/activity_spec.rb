require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "validations" do
    describe "constraints" do
      it { should validate_uniqueness_of(:identifier) }
    end

    context "when title is blank" do
      subject { build(:activity, title: nil, wizard_status: :purpose) }
      it { should validate_presence_of(:title) }
    end

    context "when description is blank" do
      subject { build(:activity, description: nil, wizard_status: :purpose) }
      it { should validate_presence_of(:description) }
    end

    context "when sector is blank" do
      subject { build(:activity, sector: nil, wizard_status: :sector) }
      it { should validate_presence_of(:sector) }
    end

    context "when status is blank" do
      subject { build(:activity, status: nil, wizard_status: :status) }
      it { should validate_presence_of(:status) }
    end

    context "when planned_start_date is blank" do
      subject { build(:activity, planned_start_date: nil, wizard_status: :dates) }
      it { should_not validate_presence_of(:planned_start_date) }
    end

    context "when planned_end_date is blank" do
      subject { build(:activity, planned_end_date: nil, wizard_status: :dates) }
      it { should_not validate_presence_of(:planned_end_date) }
    end

    context "when actual_start_date is blank" do
      subject { build(:activity, actual_start_date: nil, wizard_status: :dates) }
      it { should_not validate_presence_of(:actual_start_date) }
    end

    context "when actual_end_date is blank" do
      subject { build(:activity, actual_end_date: nil, wizard_status: :dates) }
      it { should_not validate_presence_of(:actual_end_date) }
    end

    context "when planned_start_date is not blank" do
      let(:activity) { build(:activity) }

      it "does not allow a planned_start_date more than 10 years ago" do
        activity = build(:activity, planned_start_date: 11.years.ago)
        expect(activity.valid?).to be_falsey
        expect(activity.errors[:planned_start_date]).to include "Date must be between 10 years ago and 25 years in the future"
      end

      it "does not allow a planned_start_date more than 25 years in the future" do
        activity = build(:activity, planned_start_date: 26.years.from_now)
        expect(activity.valid?).to be_falsey
      end

      it "allows a planned_start_date between 10 years ago and 25 years in the future" do
        activity = build(:activity, planned_start_date: Date.today)
        expect(activity.valid?).to be_truthy
      end
    end

    context "when recipient_region is blank" do
      subject { build(:activity, recipient_region: nil, wizard_status: :country) }
      it { should validate_presence_of(:recipient_region) }
    end

    context "when flow is blank" do
      subject { build(:activity, flow: nil, wizard_status: :flow) }
      it { should validate_presence_of(:flow) }
    end

    context "when finance is blank" do
      subject { build(:activity, finance: nil, wizard_status: :finance) }
      it { should validate_presence_of(:finance) }
    end

    context "when tied_status is blank" do
      subject { build(:activity, tied_status: nil, wizard_status: :tied_status) }
      it { should validate_presence_of(:tied_status) }
    end

    context "when the wizard_status is complete" do
      subject { build(:activity, wizard_status: "complete") }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:sector) }
      it { should validate_presence_of(:status) }
      it { should_not validate_presence_of(:planned_start_date) }
      it { should_not validate_presence_of(:planned_end_date) }
      it { should_not validate_presence_of(:actual_start_date) }
      it { should_not validate_presence_of(:actual_end_date) }
      it { should validate_presence_of(:recipient_region) }
      it { should validate_presence_of(:flow) }
      it { should validate_presence_of(:finance) }
      it { should validate_presence_of(:tied_status) }
    end
  end

  describe "relations" do
    it { should belong_to(:organisation) }
  end
end
