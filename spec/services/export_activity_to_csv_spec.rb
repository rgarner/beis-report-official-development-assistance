require "rails_helper"
require "csv"

RSpec.describe ExportActivityToCsv do
  let(:project) { create(:project_activity) }

  describe "#call" do
    it "creates a CSV line representation of the Activity" do
      activity_presenter = ActivityPresenter.new(project)
      result = ExportActivityToCsv.new(activity: project).call

      expect(result).to eq([
        activity_presenter.identifier,
        activity_presenter.transparency_identifier,
        activity_presenter.sector,
        activity_presenter.title,
        activity_presenter.description,
        activity_presenter.status,
        activity_presenter.planned_start_date,
        activity_presenter.actual_start_date,
        activity_presenter.planned_end_date,
        activity_presenter.actual_end_date,
        activity_presenter.recipient_region,
        activity_presenter.recipient_country,
        activity_presenter.aid_type,
        activity_presenter.level,
        activity_presenter.transactions_total,
        activity_presenter.link_to_roda,
      ].to_csv)
    end
  end

  describe "#headers" do
    it "uses the current report financial quarter to generate the actuals total column " do
      travel_to(Date.parse("1 April 2020")) do
        report = Report.new

        headers = ExportActivityToCsv.new.headers(report: report)

        expect(headers).to include "Q1 2020-2021 actuals"
      end
    end
  end
end