# frozen_string_literal: true

class Staff::ReportActualsController < Staff::BaseController
  include Secured
  include Reports::Breadcrumbed

  def show
    @report = Report.find(params["report_id"])
    authorize @report

    prepare_default_report_trail @report

    @report_presenter = ReportPresenter.new(@report)
    @report_activities = @report.reportable_activities
    @total_transaction = @report_presenter.summed_transactions
    @total_refund = @report_presenter.summed_refunds
    @grouped_transactions = Transaction::GroupedTransactionFetcher.new(@report).call
    @grouped_refunds = Refund::GroupedRefundFetcher.new(@report).call

    render "staff/reports/actuals"
  end
end