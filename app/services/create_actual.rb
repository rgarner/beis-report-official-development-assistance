class CreateActual
  attr_accessor :activity, :report, :actual, :user

  def initialize(activity:, report: nil, user: nil)
    self.activity = activity
    self.report = report || Report.editable_for_activity(activity)
    self.actual = Actual.new
    self.user = user
  end

  def call(attributes: {})
    actual.parent_activity = activity
    actual.assign_attributes(attributes)

    convert_and_assign_value(actual, attributes[:value])

    actual.description = default_description if actual.description.nil?
    actual.transaction_type = Transaction::DEFAULT_TRANSACTION_TYPE if actual.transaction_type.nil?
    actual.providing_organisation_name = activity.providing_organisation.name
    actual.providing_organisation_type = activity.providing_organisation.organisation_type
    actual.providing_organisation_reference = activity.providing_organisation.iati_reference

    unless activity.organisation.service_owner?
      actual.report = report
    end

    context = user&.organisation&.service_owner? ? :backfill : nil
    result = if actual.valid?(context)
      Result.new(actual.save(context: context), actual)
    else
      Result.new(false, actual)
    end

    result
  end

  private

  def convert_and_assign_value(actual, value)
    actual.value = ConvertFinancialValue.new.convert(value.to_s)
  rescue ConvertFinancialValue::Error
    actual.errors.add(:value, I18n.t("activerecord.errors.models.actual.attributes.value.not_a_number"))
  end

  def default_description
    quarter = actual.financial_quarter_and_year
    return nil unless quarter.present?

    "#{quarter} spend on #{activity.title}"
  end
end
