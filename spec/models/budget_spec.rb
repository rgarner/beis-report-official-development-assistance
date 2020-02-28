require "rails_helper"

RSpec.describe Budget do
  describe "relations" do
    it { should belong_to(:activity) }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:budget_type) }
    it { should validate_presence_of(:period_start_date) }
    it { should validate_presence_of(:period_end_date) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:currency) }
  end

  context "value must be between 1 and 99,999,999,999.00 (100 billion minus one)" do
    it "allows the maximum possible value" do
      budget = build(:budget, value: 99_999_999_999.00)
      expect(budget).to be_valid
    end

    it "does not allow a value of less than 1" do
      budget = build(:budget, value: -1)
      expect(budget).to_not be_valid
    end

    it "does not allow a value of more than 99,999,999,999.00" do
      budget = build(:budget, value: 100_000_000_000.00)
      expect(budget).to_not be_valid
    end

    it "allows a value between 1 and 99,999,999,999.00" do
      budget = build(:budget, value: 500_000.00)
      expect(budget).to be_valid
    end
  end

  context "date must be between 10 years ago and 25 years from now" do
    it "does not allow a date more than 10 years ago" do
      budget = build(:budget, period_start_date: 11.years.ago)
      expect(budget).to_not be_valid
      expect(budget.errors[:period_start_date]).to include "Date must be between 10 years ago and 25 years in the future"
    end

    it "does not allow a date more than 25 years in the future" do
      budget = build(:budget, period_start_date: 26.years.from_now)
      expect(budget).to_not be_valid
      expect(budget.errors[:period_start_date]).to include "Date must be between 10 years ago and 25 years in the future"
    end

    it "allows a date between 10 years ago and 25 years in the future" do
      budget = build(:budget, period_start_date: Date.today)
      expect(budget).to be_valid
    end

    it "does not allow nil date" do
      budget = build(:budget, period_start_date: nil)
      expect(budget).to_not be_valid
    end
  end

  context "when the period start and period end dates are blank" do
    it "does not perform budget date validation" do
      budget = build(:budget, period_start_date: "", period_end_date: "")

      budget.valid?

      expect(budget.errors[:period_end_date]).not_to include I18n.t("activerecord.errors.models.budget.attributes.period_end_date.within_365_days_of_start_date")
    end
  end

  context "when the period start and period end dates are invalid" do
    it "performs budget date validation" do
      budget = build(:budget, period_start_date: Date.today, period_end_date: Date.today + 366.days)

      budget.valid?

      expect(budget.errors[:period_end_date]).to include I18n.t("activerecord.errors.models.budget.attributes.period_end_date.within_365_days_of_start_date")
    end
  end
end
