FactoryBot.define do
  factory :activity do
    title { Faker::Lorem.sentence }
    identifier { "GCRF-#{Faker::Alphanumeric.alpha(number: 5).upcase!}" }
    description { Faker::Lorem.paragraph }
    sector { "11110" }
    status { "2" }
    planned_start_date { Date.today }
    planned_end_date { Date.tomorrow }
    actual_start_date { Date.yesterday }
    actual_end_date { Date.today }
    recipient_region { "489" }
    flow { "10" }
    finance { "110" }
    aid_type { "A01" }
    tied_status { "3" }
    level { :fund }

    wizard_status { "complete" } # wizard is complete

    association :organisation, factory: :organisation
    before(:create) do |activity|
      activity.reporting_organisation_reference = activity.organisation.iati_reference
    end

    factory :fund_activity do
      level { :fund }
      funding_organisation_name { "HM Treasury" }
      funding_organisation_reference { "GB-GOV-2" }
      funding_organisation_type { "10" }
      accountable_organisation_name { "Department for Business, Energy and Industrial Strategy" }
      accountable_organisation_reference { "GB-GOV-13" }
      accountable_organisation_type { "10" }

      association :extending_organisation, factory: :beis_organisation
    end

    factory :programme_activity do
      activity factory: :fund_activity
      level { :programme }
      funding_organisation_name { "Department for Business, Energy and Industrial Strategy" }
      funding_organisation_reference { "GB-GOV-13" }
      funding_organisation_type { "10" }
      accountable_organisation_name { "Department for Business, Energy and Industrial Strategy" }
      accountable_organisation_reference { "GB-GOV-13" }
      accountable_organisation_type { "10" }

      association :extending_organisation, factory: :beis_organisation
    end

    factory :project_activity do
      level { :project }
      funding_organisation_name { "Department for Business, Energy and Industrial Strategy" }
      funding_organisation_reference { "GB-GOV-13" }
      funding_organisation_type { "10" }
      accountable_organisation_name { "Department for Business, Energy and Industrial Strategy" }
      accountable_organisation_reference { "GB-GOV-13" }
      accountable_organisation_type { "10" }

      association :extending_organisation, factory: :beis_organisation

      factory :project_activity_with_implementing_organisations do
        transient do
          implementing_organisations_count { 3 }
        end

        after(:create) do |project_activity, evaluator|
          create_list(:implementing_organisation, evaluator.implementing_organisations_count, activity: project_activity)
        end
      end
    end
  end

  trait :at_identifier_step do
    identifier { nil }
    wizard_status { "identifier" }
    title { nil }
    description { nil }
    sector { nil }
    status { nil }
    planned_start_date { nil }
    planned_end_date { nil }
    actual_start_date { nil }
    actual_end_date { nil }
    recipient_region { nil }
    flow { nil }
    finance { nil }
    aid_type { nil }
    tied_status { nil }
  end

  trait :at_purpose_step do
    wizard_status { "identifier" }
    title { nil }
    description { nil }
    sector { nil }
    status { nil }
    planned_start_date { nil }
    planned_end_date { nil }
    actual_start_date { nil }
    actual_end_date { nil }
    recipient_region { nil }
    flow { nil }
    finance { nil }
    aid_type { nil }
    tied_status { nil }
  end

  trait :at_country_step do
    wizard_status { "country" }
    flow { nil }
    finance { nil }
    aid_type { nil }
    tied_status { nil }
  end

  trait :nil_wizard_status do
    wizard_status { nil }
  end
end
