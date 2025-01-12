class OrganisationValidator < ActiveModel::Validator
  def validate(activity)
    case activity.level
    when "fund"
      activity.errors.add(error_message(level: "fund")) unless activity.organisation.service_owner?
    when "programme"
      activity.errors.add(error_message(level: "programme")) unless activity.organisation.service_owner?
    when "project"
      activity.errors.add(error_message(level: "project")) unless activity.organisation.delivery_partner?
    when "third_party_project"
      activity.errors.add(error_message(level: "third_party_project")) unless activity.organisation.delivery_partner?
    end
  end

  private def error_message(level:)
    I18n.t("activerecord.errors.models.activity.attributes.organisation_id.#{level}.invalid")
  end
end
