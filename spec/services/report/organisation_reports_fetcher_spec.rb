require "rails_helper"

RSpec.describe Report::OrganisationReportsFetcher do
  let(:organisation) { build(:delivery_partner_organisation) }

  let(:fetcher) { described_class.new(organisation: organisation) }

  describe "#historic" do
    subject { fetcher.historic }

    it "returns approved reports for an organisation" do
      approved_reports = build_list(:report, 3, organisation: organisation)

      approved_relation_double = double(ActiveRecord::Relation)

      expect(Report).to receive(:where).with(organisation: organisation).and_return(approved_relation_double)
      expect(approved_relation_double).to receive(:approved).and_return(approved_relation_double)

      expect(approved_relation_double).to receive(:includes).with([:fund]).and_return(approved_relation_double)
      expect(approved_relation_double).to receive(:order).with("financial_year, financial_quarter DESC").and_return(approved_reports)

      expect(subject).to eq(approved_reports)
    end
  end

  describe "#current" do
    subject { fetcher.current }

    it "returns unapproved reports for an organisation" do
      unapproved_reports = build_list(:report, 2, organisation: organisation)

      unapproved_relation_double = double(ActiveRecord::Relation, "[]": unapproved_reports)

      expect(Report).to receive(:where).with(organisation: organisation).and_return(unapproved_relation_double)
      expect(unapproved_relation_double).to receive(:not_approved).and_return(unapproved_relation_double)

      expect(unapproved_relation_double).to receive(:includes).with([:fund]).and_return(unapproved_relation_double)
      expect(unapproved_relation_double).to receive(:order).with("financial_year, financial_quarter DESC").and_return(unapproved_reports)

      expect(subject).to eq(unapproved_reports)
    end
  end
end