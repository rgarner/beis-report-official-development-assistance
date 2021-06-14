class RemoveExtendingOrganisationReferenceFromActivity < ActiveRecord::Migration[6.1]
  def change
    remove_reference :activities, :extending_organisation, type: :uuid, foreign_key: {to_table: :organisations}
  end
end
