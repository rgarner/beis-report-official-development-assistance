class Staff::UploadsController < Staff::BaseController
  after_action :skip_policy_scope

  def index
    @organisations = Report.active
      .includes(:organisation)
      .map(&:organisation)
      .sort_by(&:name)
      .uniq
  end
end
