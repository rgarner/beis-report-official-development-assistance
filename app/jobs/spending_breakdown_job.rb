require "csv"

class SpendingBreakdownJob < ApplicationJob
  def perform(requester_id:, fund_id:, organisation_id: nil)
    requester = User.find(requester_id)
    fund = Fund.new(fund_id)
    organisation = Organisation.find(organisation_id) if organisation_id

    export = Export::SpendingBreakdown.new(source_fund: fund, organisation: organisation)
    file_url = save_csv_file_to_s3(export)
    email_link_to_requester(recipient: requester, file_url: file_url, file_name: export.filename)
  end

  def save_csv_file_to_s3(export)
    client = Aws::S3::Client.new(
      region: 'region',
      credentials: credentials
    )

    obj = Aws::S3::Object.new('your-bucket-here', 'path-to-output', client: client)

    file = Tempfile.new("actuals.csv")
    file.write(export.headers)
    file.write(export.rows)
    file.close

    # do upload bit here
    file.unlink
  end

  def email_link_to_requester(recipient:, file_url:, file_name:)
    view_mail(ENV["NOTIFY_VIEW_TEMPLATE"],
              to: recipient.email,
              subject: "Export #{file_name} from BEIS RODA",
              body: "Your export #{file_name} can be downloaded from #{file_url}"
    )
  end
end
