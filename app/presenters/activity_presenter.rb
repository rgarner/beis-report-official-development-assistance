# frozen_string_literal: true

class ActivityPresenter < SimpleDelegator
  def aid_type
    return if super.blank?
    I18n.t("activity.aid_type.#{super.downcase}")
  end

  def sector
    return if super.blank?
    I18n.t("activity.sector.#{super}")
  end

  def status
    return if super.blank?
    I18n.t("activity.status.#{super}")
  end

  def planned_start_date
    return if super.blank?
    I18n.l(super)
  end

  def planned_end_date
    return if super.blank?
    I18n.l(super)
  end

  def actual_start_date
    return if super.blank?
    I18n.l(super)
  end

  def actual_end_date
    return if super.blank?
    I18n.l(super)
  end

  def recipient_region
    return if super.blank?
    I18n.t("activity.recipient_region.#{super}")
  end

  def flow
    return if super.blank?
    I18n.t("activity.flow.#{super}")
  end

  def finance
    return if super.blank?
    I18n.t("activity.finance.#{super}")
  end

  def tied_status
    return if super.blank?
    I18n.t("activity.tied_status.#{super}")
  end

  def call_to_action(attribute)
    send(attribute).present? ? "edit" : "add"
  end

  def display_title
    return "Untitled (#{id})" if title.nil?
    title
  end
end
