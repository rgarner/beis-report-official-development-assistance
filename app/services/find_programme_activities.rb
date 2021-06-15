class FindProgrammeActivities
  include Pundit

  attr_accessor :organisation, :user, :fund_id

  def initialize(organisation:, user:, fund_id: nil)
    @organisation = organisation
    @user = user
    @fund_id = fund_id
  end

  def call
    programmes = ProgrammePolicy::Scope.new(user, Activity.programme)
      .resolve
      .includes(:organisation, :implementing_organisations, :budgets, :parent)
      .order("created_at ASC")

    return programmes if organisation.service_owner?

    query_conditions = {organisation_id: organisation.id}
    query_conditions[:parent_id] = fund_id if fund_id.present?

    programmes.where(query_conditions)
  end
end
