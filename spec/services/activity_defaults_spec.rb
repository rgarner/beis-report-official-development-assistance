require "rails_helper"

RSpec.describe ActivityDefaults do
  let(:beis) { create(:beis_organisation) }
  let(:delivery_partner_organisation) { create(:delivery_partner_organisation) }

  let(:fund) { create(:fund_activity, :gcrf) }
  let(:programme) { create(:programme_activity, :gcrf_funded, parent: fund) }
  let(:project) { create(:project_activity, :gcrf_funded, parent: programme) }
  let(:third_party_project) { create(:third_party_project_activity, :gcrf_funded, parent: project) }

  describe "#call" do
    subject do
      described_class.new(
        parent_activity: parent_activity,
        delivery_partner_organisation: delivery_partner_organisation
      ).call
    end

    context "parent is a fund" do
      let(:parent_activity) { fund }

      it "sets level to 'programme'" do
        expect(subject[:level]).to eq("programme")
      end

      it "sets the parent to the parent activity" do
        expect(subject[:parent_id]).to eq(fund.id)
      end

      it "sets the source_fund_code to the parent activity's source fund id" do
        expect(subject[:source_fund_code]).to eq(fund.source_fund.id)
      end

      it "sets the organisation to BEIS" do
        expect(subject[:organisation_id]).to eq(beis.id)
      end

      it "sets the extending organisation to the delivery partner organisation" do
        expect(subject[:extending_organisation_id]).to eq(delivery_partner_organisation.id)
      end

      it "sets the reporting organisation to BEIS" do
        expect(subject[:reporting_organisation_id]).to eq(beis.id)
      end

      it "sets the accountable organisation attributes to BEIS" do
        expect(subject[:accountable_organisation_name]).to eq(beis.name)
        expect(subject[:accountable_organisation_reference]).to eq(beis.iati_reference)
        expect(subject[:accountable_organisation_type]).to eq(beis.organisation_type)
      end

      it "sets the form_state to 'identifier', as we already have the level and parent" do
        expect(subject[:form_state]).to eq("identifier")
      end
    end

    context "parent is a programe" do
      let(:parent_activity) { programme }

      it "sets level to 'project'" do
        expect(subject[:level]).to eq("project")
      end

      it "sets the parent to the parent activity" do
        expect(subject[:parent_id]).to eq(programme.id)
      end

      it "sets the source_fund_code to the parent activity's source fund id" do
        expect(subject[:source_fund_code]).to eq(programme.source_fund.id)
      end

      it "sets the organisation to the delivery partner organisation" do
        expect(subject[:organisation_id]).to eq(delivery_partner_organisation.id)
      end

      it "sets the extending organisation to the delivery partner organisation" do
        expect(subject[:extending_organisation_id]).to eq(delivery_partner_organisation.id)
      end

      it "sets the reporting organisation to BEIS" do
        expect(subject[:reporting_organisation_id]).to eq(beis.id)
      end

      it "sets the accountable organisation attributes to BEIS" do
        expect(subject[:accountable_organisation_name]).to eq(beis.name)
        expect(subject[:accountable_organisation_reference]).to eq(beis.iati_reference)
        expect(subject[:accountable_organisation_type]).to eq(beis.organisation_type)
      end

      it "sets the form_state to 'identifier', as we already have the level and parent" do
        expect(subject[:form_state]).to eq("identifier")
      end
    end

    context "parent is a project" do
      let(:parent_activity) { project }

      it "sets level to 'third_party_project'" do
        expect(subject[:level]).to eq("third_party_project")
      end

      it "sets the parent to the parent activity" do
        expect(subject[:parent_id]).to eq(project.id)
      end

      it "sets the source_fund_code to the parent activity's source fund id" do
        expect(subject[:source_fund_code]).to eq(fund.source_fund.id)
      end

      it "sets the organisation to the delivery partner organisation" do
        expect(subject[:organisation_id]).to eq(delivery_partner_organisation.id)
      end

      it "sets the extending organisation to the delivery partner organisation" do
        expect(subject[:extending_organisation_id]).to eq(delivery_partner_organisation.id)
      end

      it "sets the reporting organisation to BEIS" do
        expect(subject[:reporting_organisation_id]).to eq(beis.id)
      end

      it "sets the accountable organisation attributes to BEIS" do
        expect(subject[:accountable_organisation_name]).to eq(beis.name)
        expect(subject[:accountable_organisation_reference]).to eq(beis.iati_reference)
        expect(subject[:accountable_organisation_type]).to eq(beis.organisation_type)
      end

      it "sets the form_state to 'identifier', as we already have the level and parent" do
        expect(subject[:form_state]).to eq("identifier")
      end
    end
  end
end
