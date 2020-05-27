require "csv"

class ProgrammeNotFoundForProject < StandardError; end
class MissingMappingFileForOrganisation < StandardError; end
class LegacyActivity
  attr_accessor :activity_node_set, :delivery_partner
  def initialize(activity_node_set:, delivery_partner:)
    self.activity_node_set = activity_node_set
    self.delivery_partner = delivery_partner
  end

  def elements
    activity_node_set.elements
  end

  def to_xml
    activity_node_set.to_xml
  end

  def identifier
    identifier_element = elements.detect { |element| element.name.eql?("iati-identifier") }
    return nil unless identifier_element.present?

    identifier_element.children.text
  end

  def infer_internal_identifier
    internal_identifier = identifier
    internal_identifier.delete_prefix!("GB-GOV-13")
    internal_identifier.delete_prefix!("-GCRF-")
    internal_identifier.delete_prefix!("-NEWT-")
    internal_identifier
  end

  def find_parent_programme
    Activity.programmes.find_by!(identifier: programme_mapping[identifier])
  rescue ActiveRecord::RecordNotFound
    raise ProgrammeNotFoundForProject.new(identifier)
  end

  private def programme_mapping
    @programme_mapping ||= begin
      rows = CSV.read("#{Rails.root}/vendor/data/iati_project_to_programme_mappings/#{delivery_partner.iati_reference}.csv", headers: [:project_id, :programme_id])
      rows_without_headers = rows[1..-1]
      rows_without_headers.each_with_object({}) { |row, hash| hash[row[:project_id]] = row[:programme_id] }
    end
  rescue Errno::ENOENT
    raise MissingMappingFileForOrganisation.new(delivery_partner.iati_reference)
  end
end