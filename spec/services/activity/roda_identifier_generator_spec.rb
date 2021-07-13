require "rails_helper"

RSpec.describe Activity::RodaIdentifierGenerator do
  let(:activity) { build(:project_activity) }

  before do
    expect(activity).to receive(:roda_identifier) { "NF-ABC1234" }
  end

  describe "#generate" do
    subject { described_class.new(activity).generate }

    it "generates a RODA identifier" do
      expect(Nanoid).to receive(:generate).with(
        size: 7, alphabet: "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"
      ).and_return("3455ABC")

      expect(subject).to eq("NF-ABC1234-3455ABC")
    end
  end
end
