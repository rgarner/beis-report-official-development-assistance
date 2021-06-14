class ActivityPolicy < ApplicationPolicy
  def show?
    return true if beis_user?
    return true if record.organisation == user.organisation
    return true if record.programme? && record.organisation_id == user.organisation.id
    false
  end

  def create?
    if beis_user?
      return true if record.fund? || record.programme?
    end
    return false unless editable_report?
    record.organisation == user.organisation
  end

  def create_child?
    case record.level
    when "fund"
      beis_user?
    when "programme", "project"
      editable_report? && record.organisation == user.organisation
    when "third_party_project"
      false
    end
  end

  def create_transfer?
    return beis_user? if record.fund? || record.programme?

    if delivery_partner_user?
      record.organisation == user.organisation && Report.editable.for_activity(record).exists?
    end
  end

  def edit?
    update?
  end

  def update?
    case record.level
    when "fund"
      beis_user?
    when "programme"
      beis_user?
    when "project", "third_party_project"
      editable_report? && record.organisation == user.organisation
    end
  end

  def redact_from_iati?
    if beis_user?
      return true if record.project? || record.third_party_project?
    end
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def editable_report?
    fund = record.associated_fund

    Report.editable.where(
      fund_id: fund.id,
      organisation_id: record.organisation_id
    ).exists?
  end
end
