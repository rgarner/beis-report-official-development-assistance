class CreateThirdPartyProjectActivity
  attr_accessor :user, :organisation_id, :project_id

  def initialize(user:, organisation_id:, project_id:)
    self.organisation_id = organisation_id
    self.project_id = project_id
    self.user = user
  end

  def call
    activity = Activity.new
    activity.organisation = creating_organisation
    activity.reporting_organisation = reporting_organisation
    activity.extending_organisation = creating_organisation

    project = Activity.find(project_id)
    project.child_activities << activity

    activity.wizard_status = "blank"
    activity.level = :third_party_project

    activity.funding_organisation_name = service_owner.name
    activity.funding_organisation_reference = service_owner.iati_reference
    activity.funding_organisation_type = service_owner.organisation_type

    activity.accountable_organisation_name = service_owner.name
    activity.accountable_organisation_reference = service_owner.iati_reference
    activity.accountable_organisation_type = service_owner.organisation_type

    activity.save(validate: false)
    activity
  end

  private

  def service_owner
    Organisation.find_by_service_owner(true)
  end

  def creating_organisation
    Organisation.find(organisation_id)
  end

  def reporting_organisation
    creating_organisation.is_government? ? service_owner : creating_organisation
  end
end