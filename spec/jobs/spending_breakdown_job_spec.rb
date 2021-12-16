require "rails_helper"

RSpec.describe SpendingBreakdownJob, type: :job do
  let(:requester) { double(:user) }
  let(:fund) { double(:fund) }

  let(:download_link) { "https://beis.example.com/export_1234.csv" }
  let(:breakdown) { instance_double(Export::SpendingBreakdown, filename: double("filename")) }
  let(:s3_uploader) { instance_double(Export::S3Uploader, upload: download_link) }

  describe "#perform" do
    before do
      allow(Export::SpendingBreakdown).to receive(:new).and_return(breakdown)
      allow(User).to receive(:find)
      allow(Fund).to receive(:new)
      allow(Export::S3Uploader).to receive(:new).and_return(s3_uploader)
    end

    it "asks the user object for the user with a given id" do
      SpendingBreakdownJob.perform_now(requester_id: "user123", fund_id: double)

      expect(User).to have_received(:find).with("user123")
    end

    it "asks the fund object for the fund with a given id" do
      SpendingBreakdownJob.perform_now(requester_id: double, fund_id: "fund123")

      expect(Fund).to have_received(:new).with("fund123")
    end

    it "using Export::SpendingBreakdown to build the breakdown" do
      SpendingBreakdownJob.perform_now(requester_id: double, fund_id: double)

      expect(Export::SpendingBreakdown).to have_received(:new)
    end
  end
end
