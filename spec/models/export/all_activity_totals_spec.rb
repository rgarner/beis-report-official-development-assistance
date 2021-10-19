RSpec.describe Export::AllActivityTotals do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @activity = create(:project_activity)

    @q1_report = create(:report, financial_quarter: 1, financial_year: 2020)
    @q4_report = create(:report, financial_quarter: 4, financial_year: 2020)

    create_q1_2020_actual_and_adjustments_in_q1_report
    create_q4_2020_actual_and_adjustments_in_q4_report

    create_q1_2020_refund_and_adjustments_in_q1_report
    create_q4_2020_refund_and_adjustments_in_q4_report

    create_q1_actual_and_refund_adjustments_in_q4_report
  end

  after(:all) do
    DatabaseCleaner.clean
  end

  context "when no report is passed in" do
    subject { described_class.new(activity: @activity, report: nil) }

    it "returns all totals for Q1 including those added in a later report" do
      all_q1_totals = {
        [@activity.id, 1, 2020, "Actual", nil] => BigDecimal(100),
        [@activity.id, 1, 2020, "Adjustment", "Actual"] => BigDecimal(600),
        [@activity.id, 1, 2020, "Adjustment", "Refund"] => BigDecimal(250),
        [@activity.id, 1, 2020, "Refund", nil] => BigDecimal(-200),
      }

      expect(subject.call).to include all_q1_totals
    end

    it "returns all totals for Q4 including those added in a later report" do
      all_q4_totals = {
        [@activity.id, 4, 2020, "Actual", nil] => BigDecimal(100),
        [@activity.id, 4, 2020, "Adjustment", "Actual"] => BigDecimal(100),
        [@activity.id, 4, 2020, "Adjustment", "Refund"] => BigDecimal(-100),
        [@activity.id, 4, 2020, "Refund", nil] => BigDecimal(-200),
      }

      expect(subject.call).to include all_q4_totals
    end
  end

  context "when the Q1 report is passed in" do
    subject { described_class.new(activity: @activity, report: @q1_report) }

    it "returns the totals up to and including Q1" do
      all_totals_at_q1 = {
        [@activity.id, 1, 2020, "Actual", nil] => BigDecimal(100),
        [@activity.id, 1, 2020, "Adjustment", "Actual"] => BigDecimal(100),
        [@activity.id, 1, 2020, "Adjustment", "Refund"] => BigDecimal(-150),
        [@activity.id, 1, 2020, "Refund", nil] => BigDecimal(-200),
      }
      expect(subject.call).to eq all_totals_at_q1
    end

    it "does not include any actual spend or refunds after Q1" do
      all_q4_totals = {
        [@activity.id, 4, 2020, "Actual", nil] => BigDecimal(100),
        [@activity.id, 4, 2020, "Adjustment", "Actual"] => BigDecimal(100),
        [@activity.id, 4, 2020, "Adjustment", "Refund"] => BigDecimal(-100),
        [@activity.id, 4, 2020, "Refund", nil] => BigDecimal(-200),
      }
      expect(subject.call).not_to include all_q4_totals
    end

    it "does not include adjustments added after the Q1 report" do
      expect(subject.call).not_to include [@activity.id, 1, 2020, "Adjustment", "Refund"] => BigDecimal(400)
      expect(subject.call).not_to include [@activity.id, 1, 2020, "Adjustment", "Actual"] => BigDecimal(500)
    end
  end

  def create_q1_2020_actual_and_adjustments_in_q1_report
    @actual = create(
      :actual,
      parent_activity: @activity,
      value: 100,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
    create(
      :adjustment,
      :actual,
      parent_activity: @activity,
      value: 200,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
    create(
      :adjustment,
      :actual,
      parent_activity: @activity,
      value: -100,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
  end

  def create_q4_2020_actual_and_adjustments_in_q4_report
    create(
      :actual,
      parent_activity: @activity,
      value: 100,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
    create(
      :adjustment,
      :actual,
      parent_activity: @activity,
      value: 200,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
    create(
      :adjustment,
      :actual,
      parent_activity: @activity,
      value: -100,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
  end

  def create_q1_2020_refund_and_adjustments_in_q1_report
    @refund = create(
      :refund,
      parent_activity: @activity,
      value: -200,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
    create(
      :adjustment,
      :refund,
      parent_activity: @activity,
      value: 50,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
    create(
      :adjustment,
      :refund,
      parent_activity: @activity,
      value: -200,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q1_report,
    )
  end

  def create_q4_2020_refund_and_adjustments_in_q4_report
    create(
      :refund,
      parent_activity: @activity,
      value: -200,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
    create(
      :adjustment,
      :refund,
      parent_activity: @activity,
      value: 100,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
    create(
      :adjustment,
      :refund,
      parent_activity: @activity,
      value: -200,
      financial_quarter: 4,
      financial_year: 2020,
      report: @q4_report,
    )
  end

  def create_q1_actual_and_refund_adjustments_in_q4_report
    create(
      :adjustment,
      :actual,
      parent_activity: @activity,
      value: 500,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q4_report,
    )
    create(
      :adjustment,
      :refund,
      parent_activity: @activity,
      value: 400,
      financial_quarter: 1,
      financial_year: 2020,
      report: @q4_report,
    )
  end
end
