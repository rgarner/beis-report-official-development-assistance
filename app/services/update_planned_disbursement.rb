class UpdatePlannedDisbursement
  attr_accessor :planned_disbursement

  def initialize(planned_disbursement:)
    self.planned_disbursement = planned_disbursement
  end

  def call(attributes: {})
    planned_disbursement.assign_attributes(attributes)

    if attributes.key?(:financial_quarter) & attributes.key?(:financial_year)
      planned_disbursement.period_start_date =
        FinancialPeriods.start_date_from_financial_quarter_and_year(attributes.fetch(:financial_quarter), attributes.fetch(:financial_year))
      planned_disbursement.period_end_date =
        FinancialPeriods.end_date_from_financial_quarter_and_year(attributes.fetch(:financial_quarter), attributes.fetch(:financial_year))
    end

    convert_and_assign_value(planned_disbursement, attributes[:value])

    result = if planned_disbursement.valid?
      Result.new(planned_disbursement.save!, planned_disbursement)
    else
      Result.new(false, planned_disbursement)
    end

    result
  end

  private

  def convert_and_assign_value(planned_disbursement, value)
    planned_disbursement.value = ConvertFinancialValue.new.convert(value.to_s)
  rescue ConvertFinancialValue::Error
    planned_disbursement.errors.add(:value, I18n.t("activerecord.errors.models.planned_disbursement.attributes.value.not_a_number"))
  end
end
