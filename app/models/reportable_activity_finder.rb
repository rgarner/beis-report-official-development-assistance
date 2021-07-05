class ReportableActivityFinder
  def initialize(report:)
    @report = report
  end

  def call
    Activity.reportable.projects_and_third_party_projects_for_report(report).with_roda_identifier
  end

  private

  attr_reader :report
end
