class SpendingBreakdown::Export
  HEADERS = [
    "RODA identifier",
    "Delivery partner identifier",
    "Delivery partner organisation",
    "Title",
    "Level",
  ]

  def initialize(source_fund:, organisation: nil)
    @organisation = organisation
    @source_fund = source_fund
    @activities = activities
    @actuals = actuals
    @refunds = refunds
  end

  def headers
    return HEADERS if @actuals.empty? && @refunds.empty?

    HEADERS + headers_from_financial_quarters.flatten
  end

  def rows
    @activities.map do |activity|
      activity_data(activity) + financial_data(activity)
    end
  end

  def filename
    [
      @source_fund.short_name,
      @organisation&.beis_organisation_reference,
      "spending_breakdown.csv",
    ].reject(&:blank?).join("_")
  end

 def test_adj(activity)
    all_totals_for_activity = Adjustment.joins("LEFT OUTER JOIN adjustment_details ON adjustment_details.adjustment_id = transactions.id")
      .where(parent_activity_id: activity.id)
      .select(:financial_quarter, :financial_year, :parent_activity_id, :value, :type, "adjustment_details.adjustment_type")
      .group(:parent_activity_id, :financial_quarter, :financial_year, :type, "adjustment_details.adjustment_type")
      .order(:parent_activity_id, :financial_quarter, :financial_year)
      .sum(:value)

    binding.pry
 end

  def financial_data(activity)
    all_totals_for_activity = Transaction.joins("LEFT OUTER JOIN adjustment_details ON adjustment_details.adjustment_id = transactions.id")
      .where(parent_activity_id: activity.id)
      .select(:financial_quarter, :financial_year, :parent_activity_id, :value, :type, "adjustment_details.adjustment_type").distinct
      .group(:parent_activity_id, :financial_quarter, :financial_year, :type, "adjustment_details.adjustment_type")
      .order(:parent_activity_id, :financial_quarter, :financial_year)
      .sum(:value)

    rows = financial_quarter_range.map { |fq|
      actual_total = all_totals_for_activity.fetch([activity.id, fq.to_i, fq.financial_year.start_year, "Actual", nil], 0)
      refund_total = all_totals_for_activity.fetch([activity.id, fq.to_i, fq.financial_year.start_year, "Refund", nil], 0)

      actual_adjustments = all_totals_for_activity.fetch([activity.id, fq.to_i, fq.financial_year.start_year, "Adjustment", "Actual"], 0)
      refund_adjustments = all_totals_for_activity.fetch([activity.id, fq.to_i, fq.financial_year.start_year, "Adjustment", "Refund"], 0)

      total_actual_figure = actual_total + actual_adjustments
      total_refund_figure = refund_total + refund_adjustments

      net_value = total_actual_figure + total_refund_figure

      [total_actual_figure, total_refund_figure, net_value]
    }
    rows.flatten!
  end
  private


  def activity_data(activity)
    [
      activity.roda_identifier,
      activity.delivery_partner_identifier,
      activity.organisation.name,
      activity.title,
      I18n.t("table.body.activity.level.#{activity.level}"),
    ]
  end

  def activities
    if @organisation.nil?
      Activity.where(source_fund_code: @source_fund.id).includes(:organisation)
    else
      Activity.includes(:organisation).where(organisation_id: @organisation.id, source_fund_code: @source_fund.id)
        .or(Activity.includes(:organisation).where(extending_organisation_id: @organisation.id, source_fund_code: @source_fund.id))
    end
  end

  def actuals
    Actual.where(parent_activity_id: activity_ids)
  end

  def refunds
    Refund.where(parent_activity_id: activity_ids)
  end

  def activity_ids
    @activities.pluck(:id)
  end

  def financial_quarters_with_acutals
    return [] unless @actuals.present?
    @actuals.map(&:own_financial_quarter).uniq
  end

  def financial_quarters_with_refunds
    return [] unless @refunds.present?
    @refunds.map(&:own_financial_quarter).uniq
  end

  def financial_quarters
    financial_quarters_with_acutals + financial_quarters_with_refunds
  end

  def headers_from_financial_quarters
    financial_quarter_range.map do |financial_quarter|
      [
        "Actual spend #{financial_quarter}",
        "Refund #{financial_quarter}",
        "Actual net #{financial_quarter}",
      ]
    end
  end

  def financial_quarter_range
    @_financial_quarter_range ||= Range.new(*financial_quarters.minmax)
  end
end
