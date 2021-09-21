RSpec.describe SpendingBreakdown::Export do
  let!(:organisation) { create(:delivery_partner_organisation) }
  let!(:activity) { create(:project_activity, organisation: organisation) }
  let!(:source_fund) { Fund.new(activity.source_fund_code) }
  let!(:actual) { create(:actual, parent_activity: activity, value: 100, financial_quarter: 1, financial_year: 2020) }
  let!(:refund) { create(:refund, parent_activity: activity, value: -200, financial_quarter: 1, financial_year: 2020) }

  let!(:positive_actual_adjustment) { create(:adjustment, :actual, parent_activity: activity, value: 200, financial_quarter:1, financial_year: 2020) }
  let!(:negative_actual_adjustment) { create(:adjustment, :actual, parent_activity: activity, value: -100, financial_quarter: 1, financial_year: 2020) }

  let!(:positive_refund_adjustment) { create(:adjustment, :refund, parent_activity: activity, value: 50, financial_quarter: 1, financial_year: 2020) }
  let!(:negative_refund_adjustment) { create(:adjustment, :refund, parent_activity: activity, value: -200, financial_quarter: 1, financial_year: 2020) }

  subject { SpendingBreakdown::Export.new(organisation: organisation, source_fund: source_fund) }

  describe "#headers" do
    it "returns a list of column headings" do
      expect(subject.headers).to eql([
        "RODA identifier",
        "Delivery partner identifier",
        "Delivery partner organisation",
        "Title",
        "Level",
        "Actual spend FQ1 2020-2021",
        "Refund FQ1 2020-2021",
        "Actual net FQ1 2020-2021",
      ])
    end
  end

  describe "#rows" do
    describe "non financial data" do
      it "conatins the appropriate values" do
        aggregate_failures do
          expect(subject.rows.first[0]).to eql(activity.roda_identifier)
          expect(subject.rows.first[1]).to eql(activity.delivery_partner_identifier)
          expect(subject.rows.first[2]).to eql(activity.organisation.name)
          expect(subject.rows.first[3]).to eql(activity.title)
          expect(subject.rows.first[4]).to eql("Project (level C)")
        end
      end
    end

    describe "financial data" do
      it "contains the total actuals including adjustments at position X" do
        expect(subject.rows.first[5].to_s).to eql("200.0")
      end

      it "contains the total refunds including adjustments at position Y" do
        expect(subject.rows.first[6].to_s).to eql("-350.0")
      end

      it "contains total actuals less total refunds, including all adjustments" do
        expect(subject.rows.first[7].to_s).to eql("-150.0")
      end
    end
  end
end
