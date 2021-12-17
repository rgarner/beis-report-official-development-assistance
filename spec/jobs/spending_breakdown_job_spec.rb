require "rails_helper"

RSpec.describe SpendingBreakdownJob, type: :job do
  let(:requester) { double(:user) }
  let(:fund) { double(:fund) }
  let(:row1) { double("row1") }
  let(:row2) { double("row1") }

  let(:breakdown) do
    instance_double(
      Export::SpendingBreakdown,
      filename: double("filename"),
      headers: %w[col1 col2],
      rows: [row1, row2]
    )
  end
  let(:tempfile) { double("tempfile") }
  let(:csv) { double("csv", "<<" => true) }

  describe "#perform" do
    before do
      allow(User).to receive(:find)
      allow(Fund).to receive(:new).and_return(fund)
      allow(Export::SpendingBreakdown).to receive(:new).and_return(breakdown)
      allow(Tempfile).to receive(:new).and_return(tempfile)
      allow(CSV).to receive(:new).and_yield(csv)
    end

    it "asks the user object for the user with a given id" do
      SpendingBreakdownJob.perform_now(requester_id: "user123", fund_id: double)

      expect(User).to have_received(:find).with("user123")
    end

    it "asks the fund object for the fund with a given id" do
      SpendingBreakdownJob.perform_now(requester_id: double, fund_id: "fund123")

      expect(Fund).to have_received(:new).with("fund123")
    end

    it "uses Export::SpendingBreakdown to build the breakdown for the given fund" do
      SpendingBreakdownJob.perform_now(requester_id: double, fund_id: double)

      expect(Export::SpendingBreakdown).to have_received(:new).with(source_fund: fund)
    end

    it "writes the breakdown to a 'tempfile'" do
      SpendingBreakdownJob.perform_now(requester_id: double, fund_id: double)

      expect(CSV).to have_received(:new).with(tempfile, {headers: true})
      expect(csv).to have_received(:<<).with(%w[col1 col2])
      expect(csv).to have_received(:<<).with(row1)
      expect(csv).to have_received(:<<).with(row2)
    end
  end
end
