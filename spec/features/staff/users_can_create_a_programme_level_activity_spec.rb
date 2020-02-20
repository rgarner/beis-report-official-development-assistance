RSpec.feature "Users can create a programme activity" do
  let(:user) { create(:beis_user) }

  context "when signed in" do
    before do
      authenticate!(user: user)
    end

    scenario "successfully create an activity" do
      fund = create(:activity, level: :fund, organisation: user.organisation)

      visit organisation_path(user.organisation)
      click_on fund.title
      click_on(I18n.t("page_content.organisation.button.create_programme"))

      fill_in_activity_form

      expect(page).to have_content I18n.t("form.programme.create.success")
    end

    scenario "the activity has the appropriate funding organisation defaults" do
      fund = create(:activity, level: :fund, organisation: user.organisation)
      identifier = "a-programme-has-a-funding-organisation"

      visit organisation_path(user.organisation)
      click_on fund.title
      click_on(I18n.t("page_content.organisation.button.create_programme"))

      fill_in_activity_form(identifier: identifier)

      activity = Activity.find_by(identifier: identifier)
      expect(activity.funding_organisation_name).to eq("Department for Business, Energy and Industrial Strategy")
      expect(activity.funding_organisation_reference).to eq("GB-GOV-13")
      expect(activity.funding_organisation_type).to eq("10")
    end

    scenario "the activity has the appropriate accountable organisation defaults" do
      fund = create(:activity, level: :fund, organisation: user.organisation)
      identifier = "a-fund-has-an-accountable-organisation"

      visit organisation_path(user.organisation)
      click_on fund.title
      click_on(I18n.t("page_content.organisation.button.create_programme"))

      fill_in_activity_form(identifier: identifier)

      activity = Activity.find_by(identifier: identifier)
      expect(activity.accountable_organisation_name).to eq("Department for Business, Energy and Industrial Strategy")
      expect(activity.accountable_organisation_reference).to eq("GB-GOV-13")
      expect(activity.accountable_organisation_type).to eq("10")
    end
  end
end