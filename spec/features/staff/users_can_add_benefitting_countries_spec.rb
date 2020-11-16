RSpec.feature "users can add benefitting countries as intended beneficiaries" do
  context "when the user is signed as a BEIS user" do
    let(:user) { create(:beis_user) }
    before { authenticate!(user: user) }
    let(:activity) { create(:activity, :at_geography_step, organisation: user.organisation, intended_beneficiaries: nil) }

    context "if they choose 'recipient country' as geography option" do
      context "after choosing one country" do
        scenario "the user will be asked if there are other benefitting countries to be added" do
          visit activity_step_path(activity, :geography)
          choose "Country"
          click_button t("form.button.activity.submit")
          expect(page).to have_select(t("form.label.activity.recipient_country"))

          select "Bolivia"
          click_button t("form.button.activity.submit")
          expect(page).to have_content t("form.legend.activity.requires_additional_benefitting_countries")
          choose "Yes"
          click_button t("form.button.activity.submit")
          expect(page).to have_content t("form.legend.activity.intended_beneficiaries")
        end

        scenario "if there are no other benefitting countries the intended_beneficiaries step will be omitted" do
          visit activity_step_path(activity, :geography)
          choose "Country"
          click_button t("form.button.activity.submit")
          expect(page).to have_select(t("form.label.activity.recipient_country"))

          select "Bolivia"
          click_button t("form.button.activity.submit")
          expect(page).to have_content t("form.legend.activity.requires_additional_benefitting_countries")
          choose "No"
          click_button t("form.button.activity.submit")
          expect(page).to have_current_path(activity_step_path(activity, :gdi))
        end
        scenario "the user has the option of selecting other intended beneficiaries based from the full list of countries available" do
          visit activity_step_path(activity, :geography)
          choose "Country"
          click_button t("form.button.activity.submit")
          expect(page).to have_select(t("form.label.activity.recipient_country"))

          select "Bolivia"
          click_button t("form.button.activity.submit")
          expect(activity.reload.recipient_region).to eq("489") # South America

          expect(page).to have_content t("form.legend.activity.requires_additional_benefitting_countries")
          choose "Yes"
          click_button t("form.button.activity.submit")

          expect(page).to have_content t("form.legend.activity.intended_beneficiaries")
          expect(page).to have_selector(".govuk-checkboxes__item", count: 145)
          expect(page).to have_content("Afghanistan")
          expect(page).to have_content("Zimbabwe")
          check "Gambia"
          check "Indonesia"
          check "Yemen"
          click_button t("form.button.activity.submit")
          activity.reload
          expect(activity.intended_beneficiaries).to eq(["GM", "ID", "YE"])
          expect(page).to have_current_path(activity_step_path(activity, :gdi))
        end

        scenario "the user will be able to select more than 10 intended beneficiaries" do
          visit activity_step_path(activity, :geography)
          choose "Country"
          click_button t("form.button.activity.submit")
          expect(page).to have_select(t("form.label.activity.recipient_country"))

          select "Burundi"
          click_button t("form.button.activity.submit")
          expect(page).to have_content t("form.legend.activity.requires_additional_benefitting_countries")
          choose "Yes"
          click_button t("form.button.activity.submit")

          expect(page).to have_content t("form.legend.activity.intended_beneficiaries")
          check "Comoros"
          check "Eritrea"
          check "Ethiopia"
          check "Kenya"
          check "Madagascar"
          check "Mozambique"
          check "Somalia"
          check "Sudan"
          check "Tanzania"
          check "Uganda"
          check "Zambia"
          click_button t("form.button.activity.submit")
          activity.reload
          expect(activity.intended_beneficiaries).to eq(["KM", "ER", "ET", "KE", "MG", "MZ", "SO", "SD", "TZ", "UG", "ZM"])
          expect(page).to have_current_path(activity_step_path(activity, :gdi))
        end
      end
    end

    context "if they choose recipient region as geography option" do
      scenario "it is required that they choose at least one intended beneficiary" do
        visit activity_step_path(activity, :geography)
        choose "Region"
        click_button t("form.button.activity.submit")
        expect(page).to have_select(t("form.label.activity.recipient_region"))

        select "Developing countries, unspecified"
        click_button t("form.button.activity.submit")
        expect(activity.reload.recipient_region).to eq("998")

        expect(page).to have_content t("form.legend.activity.intended_beneficiaries")
        expect(page).to have_content("Afghanistan")
        expect(page).to have_content("Zimbabwe")
        # Don't select any countries
        click_button t("form.button.activity.submit")
        expect(page).to have_content t("activerecord.errors.models.activity.attributes.intended_beneficiaries.blank")

        check "Kenya"
        check "Turkey"
        click_button t("form.button.activity.submit")
        activity.reload
        expect(activity.intended_beneficiaries).to eq(["KE", "TR"])
      end

      context "if they choose one of the wider regions" do
        scenario "they will be able to select benefitting countries from the sub-regions the wider region maps to" do
          visit activity_step_path(activity, :geography)
          choose "Region"
          click_button t("form.button.activity.submit")
          expect(page).to have_content t("form.label.activity.recipient_region")

          select "Africa, regional"
          click_button t("form.button.activity.submit")
          expect(activity.reload.recipient_region).to eq("298")

          expect(page).to have_content t("form.legend.activity.intended_beneficiaries")
          expect(page).to have_selector(".govuk-checkboxes__item", count: 54)
          expect(page).to have_content("Algeria")
          expect(page).to have_content("Zimbabwe")
          expect(page).to_not have_content("Ukraine")

          check "Cameroon"
          check "Mozambique"
          check "Senegal"
          check "Egypt"
          click_button t("form.button.activity.submit")
          activity.reload
          expect(activity.intended_beneficiaries).to eq(["CM", "EG", "MZ", "SN"])
        end
      end
    end
  end
end
