require "rails_helper"

RSpec.describe SpendingBreakdownJob, type: :job do
  let(:requester) { double(:user) }
  let(:fund) { double(:fund) }
  let(:organisation) { double(:organisation) }

  describe "#perform" do
    before do
      allow(Export::SpendingBreakdown).to receive(:new)
      allow(User).to receive(:find)
      allow(Fund).to receive(:new)
    end

    context "when the organisation_id is nil" do
      it "asks the user object for the user with a given id" do
        SpendingBreakdownJob.perform_now(requester_id: "abcd123", fund_id: "fundabcs123")
        expect(User).to have_received(:find).with("abcd123")
      end

      it "asks the fund object for the fund with a given id" do
        SpendingBreakdownJob.perform_now(requester_id: "abcd123", fund_id: "fundabcs123")
        expect(User).to have_received(:find).with("abcd123")
      end

      it "calls Export::SpendingBreakdown" do
        SpendingBreakdownJob.perform_now(requester_id: "abcd123", fund_id: "fundabcs123")
        expect(Export::SpendingBreakdown).to have_received(:new)
      end
    end

    context "when the organisation_id is nil" do

    end

    context "when the fund_id is not found" do

    end

    context "when the requester_id is not found" do

    end
  end

  describe "#save_csv_file_to_s3" do

  end

  describe "#email_link_to_requester" do

  end
end
