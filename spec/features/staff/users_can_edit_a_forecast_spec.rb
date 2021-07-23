RSpec.describe "Users can edit a forecast" do
  context "when signed in as a delivery partner" do
    let(:user) { create(:delivery_partner_user) }
    let(:programme) { create(:programme_activity, extending_organisation: user.organisation) }
    let(:project) { create(:project_activity, organisation: user.organisation, parent: programme) }
    let(:forecast) { ForecastOverview.new(project).latest_values.first }

    before do
      authenticate!(user: user)
      ReportingCycle.new(project, 1, 2018).tick
      ForecastHistory.new(project, financial_quarter: 2, financial_year: 2018).set_value(40)
    end

    scenario "they can edit a forecast" do
      visit organisation_activity_path(project.organisation, project)

      within "##{forecast.id}" do
        click_on "Edit"
      end

      expect(page).to have_http_status(:success)

      fill_in "Forecasted spend amount", with: "£20000"
      click_button "Submit"

      expect(page).to have_content t("action.forecast.update.success")
      expect(page).to have_content "£20,000"
    end

    scenario "the correct financial quarter and year are selected" do
      visit organisation_activity_path(project.organisation, project)
      within "##{forecast.id}" do
        click_on "Edit"
      end

      expect(page).to have_content("Edit forecasted spend for FQ2 2018-2019")
    end

    scenario "they do not see the edit link when they cannot edit" do
      Report.update_all(state: :approved)

      visit organisation_activity_path(project.organisation, project)

      expect(page).not_to have_link t("default.link.edit"),
        href: edit_activity_forecasts_path(project, forecast.financial_year, forecast.financial_quarter)
    end

    scenario "they receive an error message if the value is not a valid number" do
      visit organisation_activity_path(project.organisation, project)

      within "##{forecast.id}" do
        click_on "Edit"
      end

      fill_in "Forecasted spend amount", with: ""
      click_button "Submit"

      expect(page).to have_content t("activerecord.errors.models.forecast.attributes.value.not_a_number")
    end

    scenario "the action is recorded with public_activity" do
      PublicActivity.with_tracking do
        visit activities_path
        click_on(project.title)
        within("##{forecast.id}") do
          click_on(t("default.link.edit"))
        end

        fill_in "forecast[value]", with: "2000.51"
        click_on(t("default.button.submit"))

        auditable_event = PublicActivity::Activity.find_by(trackable_id: forecast.id)
        expect(auditable_event.key).to eq "forecast.update"
        expect(auditable_event.owner_id).to eq user.id
      end
    end
  end
end