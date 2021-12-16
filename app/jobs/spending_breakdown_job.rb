require "csv"

class SpendingBreakdownJob < ApplicationJob
  def perform(requester_id:, fund_id:, organisation_id: nil)
    requester = User.find(requester_id)
    fund = Fund.new(fund_id)
    organisation = Organisation.find(organisation_id) if organisation_id

    export = Export::SpendingBreakdown.new(source_fund: fund, organisation: organisation)
    file = save_file(export)
    file_url = save_csv_file_to_s3(file)
    DownloadLinkMailer.email_requester(recipient: requester, file_url: file_url, file_name: export.filename)
  end

  def save_csv_file_to_s3(file)
    uploader = S3Uploader.new(file)
    file_url = uploader.upload
    file_url
  end

  def save_file(export)
    tmpfile = Tempfile.new
    CSV.new(tmpfile, {headers: true}) do |csv|
      csv << export.headers
      export.rows.each do |row|
        csv << row
      end
    end
    tmpfile
  end
end
