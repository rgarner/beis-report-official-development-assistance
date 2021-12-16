require "rails_helper"

RSpec.describe SpendingBreakdownJob, type: :job do
  let(:requester) { create(:beis_user) }
  let(:fund) { create(:fund_activity) }
  let(:organisation) { fund.organisation }

  describe "#perform" do
    context "when the organisation_id is not nil" do
      it "does some things" do
        expect(described_class.perform_later(requester_id: requester.id, fund_id: fund.id, organisation_id: organisation.id)).to eq([])
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
