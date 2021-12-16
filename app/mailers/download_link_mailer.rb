class DownloadLinkMailer < ApplicationMailer
  def email_requester(recipient:, file_url:, file_name:)
    view_mail(ENV["NOTIFY_VIEW_TEMPLATE"],
              to: recipient.email,
              subject: "Export #{file_name} from BEIS RODA",
              body: "Your export #{file_name} can be downloaded from #{file_url}"
    )
  end
end
