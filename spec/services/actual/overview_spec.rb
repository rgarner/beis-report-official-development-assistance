RSpec.describe Actual::Overview do
  let(:delivery_partner) { create(:delivery_partner_organisation) }
  let(:project) { create(:project_activity, organisation: delivery_partner) }
  let(:reporting_cycle) { ReportingCycle.new(project, 4, 2018) }
  let(:include_adjustments) { false }
  let(:overview) { described_class.new(report: report, include_adjustments: include_adjustments) }

  #   Report:     2018-Q4     2019-Q1     2019-Q2
  #   Quarter
  #   -------------------------------------------
  #   2017-Q1          10
  #   2017-Q2                     320
  #   2017-Q3                               5,120
  #   2017-Q4          20         640
  #   2018-Q1          40                  10,240
  #   2018-Q2                   1,280      20,480
  #   2018-Q3          80       2,560      40,960
  #   2018-Q4         160                  81,920

  before do
    reporting_cycle.tick
    create_actual(financial_year: 2017, financial_quarter: 1, value: 10)
    create_actual(financial_year: 2017, financial_quarter: 4, value: 20)
    create_actual(financial_year: 2018, financial_quarter: 1, value: 40)
    create_actual(financial_year: 2018, financial_quarter: 3, value: 80)
    create_actual(financial_year: 2018, financial_quarter: 4, value: 160)

    create_adjustment(financial_year: 2017, financial_quarter: 1, value: 20, adjustment_type: :actual)
    create_adjustment(financial_year: 2017, financial_quarter: 4, value: -5, adjustment_type: :actual)
    create_adjustment(financial_year: 2017, financial_quarter: 4, value: 900, adjustment_type: :refund)

    reporting_cycle.tick
    create_actual(financial_year: 2017, financial_quarter: 2, value: 320)
    create_actual(financial_year: 2017, financial_quarter: 4, value: 640)
    create_actual(financial_year: 2018, financial_quarter: 2, value: 1_280)
    create_actual(financial_year: 2018, financial_quarter: 3, value: 2_560)

    create_adjustment(financial_year: 2017, financial_quarter: 2, value: -20, adjustment_type: :actual)
    create_adjustment(financial_year: 2017, financial_quarter: 2, value: 1000, adjustment_type: :refund)

    reporting_cycle.tick
    create_actual(financial_year: 2017, financial_quarter: 3, value: 5_120)
    create_actual(financial_year: 2018, financial_quarter: 1, value: 10_240)
    create_actual(financial_year: 2018, financial_quarter: 2, value: 20_480)
    create_actual(financial_year: 2018, financial_quarter: 3, value: 40_960)
    create_actual(financial_year: 2018, financial_quarter: 4, value: 81_920)

    create_adjustment(financial_year: 2017, financial_quarter: 3, value: -100, adjustment_type: :actual)
    create_adjustment(financial_year: 2017, financial_quarter: 3, value: -9999, adjustment_type: :refund)
  end

  context "for the first report" do
    let(:report) { Report.for_activity(project).find_by(financial_quarter: 4, financial_year: 2018) }

    let(:expected_values) {
      [
        [1, 2017, 10],
        [2, 2017, 0],
        [3, 2017, 0],
        [4, 2017, 20],
        [1, 2018, 40],
        [2, 2018, 0],
        [3, 2018, 80],
        [4, 2018, 160],
      ]
    }

    it_should_behave_like "transaction report history"

    context "when adjustments are included" do
      let(:include_adjustments) { true }
      let(:expected_values) {
        [
          [1, 2017, 30],
          [2, 2017, 0],
          [3, 2017, 0],
          [4, 2017, 15],
          [1, 2018, 40],
          [2, 2018, 0],
          [3, 2018, 80],
          [4, 2018, 160],
        ]
      }

      it_should_behave_like "transaction report history"
    end
  end

  context "for the middle report" do
    let(:report) { Report.for_activity(project).find_by(financial_quarter: 1, financial_year: 2019) }

    let(:expected_values) {
      [
        [1, 2017, 10],
        [2, 2017, 320],
        [3, 2017, 0],
        [4, 2017, 660],
        [1, 2018, 40],
        [2, 2018, 1_280],
        [3, 2018, 2_640],
        [4, 2018, 160],
      ]
    }

    it_should_behave_like "transaction report history"

    context "when adjustments are included" do
      let(:include_adjustments) { true }
      let(:expected_values) {
        [
          [1, 2017, 30],
          [2, 2017, 300],
          [3, 2017, 0],
          [4, 2017, 655],
          [1, 2018, 40],
          [2, 2018, 1_280],
          [3, 2018, 2_640],
          [4, 2018, 160],
        ]
      }

      it_should_behave_like "transaction report history"
    end
  end

  context "for the latest report" do
    let(:report) { Report.for_activity(project).find_by(financial_quarter: 2, financial_year: 2019) }

    let(:expected_values) {
      [
        [1, 2017, 10],
        [2, 2017, 320],
        [3, 2017, 5_120],
        [4, 2017, 660],
        [1, 2018, 10_280],
        [2, 2018, 21_760],
        [3, 2018, 43_600],
        [4, 2018, 82_080],
      ]
    }

    it_should_behave_like "transaction report history"

    context "when adjustments are included" do
      let(:include_adjustments) { true }
      let(:expected_values) {
        [
          [1, 2017, 30],
          [2, 2017, 300],
          [3, 2017, 5_020],
          [4, 2017, 655],
          [1, 2018, 10_280],
          [2, 2018, 21_760],
          [3, 2018, 43_600],
          [4, 2018, 82_080],
        ]
      }

      it_should_behave_like "transaction report history"
    end
  end
end
