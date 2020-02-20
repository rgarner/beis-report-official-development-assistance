RSpec.feature "Users can view fund level activities" do
  context "when the user is not logged in" do
    it "redirects the user to the root path" do
      organisation = create(:organisation)
      page.set_rack_session(userinfo: nil)
      visit organisation_path(organisation)
      expect(current_path).to eq(root_path)
    end
  end

  let(:user) { create(:beis_user) }

  before do
    authenticate!(user: user)
  end

  scenario "can view a fund level activity" do
    fund_activity = create(:activity, level: :fund, organisation: user.organisation)

    visit organisation_path(user.organisation)
    click_on fund_activity.title

    page_displays_an_activity(activity_presenter: ActivityPresenter.new(fund_activity))
  end

  scenario "can view and create programme level activities" do
    fund_activity = create(:activity, level: :fund, organisation: user.organisation)
    programme_activity = create(:activity, level: :programme)
    fund_activity.activities << programme_activity
    activity_presenter = ActivityPresenter.new(programme_activity)
    visit organisation_activity_path(fund_activity.organisation, fund_activity)

    expect(page).to have_link activity_presenter.display_title
    expect(page).to have_button I18n.t("page_content.organisation.button.create_programme")
  end

  context "when the activity is partially complete and doesn't have a title" do
    scenario "it to show a meaningful link to the activity" do
      activity = create(:activity, :at_purpose_step, organisation: user.organisation, title: nil)

      visit organisation_path(user.organisation)

      expect(page).to have_content("Untitled (#{activity.id})")
    end
  end

  scenario "can go back to the previous page" do
    activity = create(:activity, organisation: user.organisation)

    visit organisation_activity_path(user.organisation, activity)

    click_on I18n.t("generic.link.back")

    expect(page).to have_current_path(organisation_path(user.organisation))
  end
end