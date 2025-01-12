RSpec.feature "Users can approve reports" do
  context "signed in as a BEIS user" do
    let!(:beis_user) { create(:beis_user) }
    let(:organisation) { create(:delivery_partner_organisation, users: create_list(:delivery_partner_user, 3)) }

    before do
      authenticate!(user: beis_user)
    end

    scenario "they can mark a report as approved" do
      report = create(:report, state: :in_review, organisation: organisation)

      perform_enqueued_jobs do
        visit report_path(report)
        click_link t("action.report.approve.button")
        click_button t("action.report.approve.confirm.button")
      end

      expect(page).to have_content "approved"
      expect(report.reload.state).to eql "approved"

      expect(ActionMailer::Base.deliveries.count).to eq(organisation.users.count + 1)

      expect(beis_user).to have_received_email.with_subject(t("mailer.report.approved.service_owner.subject", application_name: t("app.title")))

      organisation.users.each do |user|
        expect(user).to have_received_email.with_subject(t("mailer.report.approved.delivery_partner.subject", application_name: t("app.title")))
      end
    end

    context "when the report is already approved" do
      scenario "it cannot be approved" do
        report = create(:report, :approved)

        visit report_path(report)

        within("#main-content") do
          expect(page).not_to have_link t("action.report.approve.button")
        end
      end
    end
  end

  context "signed in as a Delivery partner user" do
    let(:delivery_partner_user) { create(:delivery_partner_user) }

    before do
      authenticate!(user: delivery_partner_user)
    end

    scenario "they cannot mark a report as approved" do
      report = create(:report, state: :in_review)

      visit report_path(report)

      expect(page).not_to have_link t("action.report.approve.button")

      visit edit_report_state_path(report)

      expect(page.status_code).to eql 401
    end
  end
end
