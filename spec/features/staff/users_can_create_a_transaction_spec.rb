RSpec.feature "Users can create a transaction" do
  context "when the user is not logged in" do
    it "redirects the user to the root path" do
      activity = create(:fund_activity)
      visit organisation_activity_path(activity.organisation, activity)
      expect(current_path).to eq(root_path)
    end
  end

  context "when the user belongs to BEIS" do
    before { authenticate!(user: user) }
    let(:user) { create(:beis_user) }

    scenario "successfully creates a transaction on an activity" do
      activity = create(:fund_activity, organisation: user.organisation)

      visit organisation_path(user.organisation)

      click_on(activity.title)

      click_on(I18n.t("page_content.transactions.button.create"))

      fill_in_transaction_form

      expect(page).to have_content(I18n.t("form.transaction.create.success"))
    end

    scenario "validations" do
      activity = create(:fund_activity, organisation: user.organisation)

      visit organisation_path(user.organisation)

      click_on(activity.title)

      click_on(I18n.t("page_content.transactions.button.create"))
      click_on(I18n.t("generic.button.submit"))

      expect(page).to_not have_content(I18n.t("form.transaction.create.success"))
      expect(page).to have_content("Reference can't be blank")
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Transaction type can't be blank")
      expect(page).to have_content("Date can't be blank")
      expect(page).to have_content("Value must be between 1 and 99,999,999,999.00")
      expect(page).to have_content("Disbursement channel can't be blank")
      expect(page).to have_content("Providing organisation name can't be blank")
      expect(page).to have_content("Providing organisation type can't be blank")
      expect(page).to have_content("Receiving organisation name can't be blank")
      expect(page).to have_content("Receiving organisation type can't be blank")
    end

    context "Value number validation" do
      scenario "Value must be between 1 and 99,999,999,999" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in "transaction[reference]", with: "123"
        fill_in "transaction[description]", with: "This money will be purchasing a new school roof"
        select "Outgoing Pledge", from: "transaction[transaction_type]"
        fill_in "transaction[date(3i)]", with: "1"
        fill_in "transaction[date(2i)]", with: "1"
        fill_in "transaction[date(1i)]", with: "2020"
        fill_in "transaction[value]", with: "100000000000"
        select "Money is disbursed through central Ministry of Finance or Treasury", from: "transaction[disbursement_channel]"
        select "Pound Sterling", from: "transaction[currency]"
        click_on(I18n.t("generic.button.submit"))

        expect(page).to have_content("Value must be between 1 and 99,999,999,999.00")
      end

      scenario "When the value includes a pound sign" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(value: "£123", expectations: false)

        expect(page).to have_content "123"
      end

      scenario "When the value includes alphabetical characters" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(value: "abc123def", expectations: false)

        expect(page).to have_content "123"
      end

      scenario "When the value includes decimal places" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(value: "100.12", expectations: false)

        expect(page).to have_content "100.12"
      end

      scenario "When the value includes commas" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(value: "123,000,000", expectations: false)

        expect(page).to have_content "£123,000,000"
      end
    end

    context "Date validation" do
      scenario "When the date is in the future" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(date_day: 0o1, date_month: 0o1, date_year: 2100, expectations: false)

        expect(page).to have_content "Date must not be in the future"
      end

      scenario "When the date is in the past" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(date_day: 0o1, date_month: 0o1, date_year: 1900, expectations: false)

        expect(page).to_not have_content "Date must not be in the future"
        expect(page).to have_content I18n.t("form.transaction.create.success")
      end

      scenario "When the date is nil" do
        activity = create(:fund_activity, organisation: user.organisation)

        visit organisation_path(user.organisation)

        click_on(activity.title)

        click_on(I18n.t("page_content.transactions.button.create"))

        fill_in_transaction_form(date_day: "", date_month: "", date_year: "", expectations: false)

        expect(page).to have_content "Date can't be blank"
      end
    end
  end

  context "when the user does NOT belong to BEIS" do
    before { authenticate!(user: user) }
    let(:user) { create(:delivery_partner_user) }

    scenario "they cannot create transactions on a programme" do
      fund_activity = create(:fund_activity, organisation: user.organisation)
      programme_activity = create(:programme_activity,
        activity: fund_activity,
        organisation: user.organisation,
        extending_organisation: user.organisation)

      visit organisation_path(user.organisation)
      click_on(programme_activity.title)

      expect(page).not_to have_content(I18n.t("page_content.activity.transactions"))
      expect(page).not_to have_content(I18n.t("page_content.transactions.button.create"))
    end
  end
end
