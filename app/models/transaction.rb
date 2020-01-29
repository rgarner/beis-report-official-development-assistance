class Transaction < ApplicationRecord
  belongs_to :activity
  belongs_to :provider, foreign_key: :provider_id, class_name: "Organisation"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "Organisation"
  validates_presence_of :reference,
    :description,
    :transaction_type,
    :date,
    :currency,
    :value,
    :disbursement_channel
  validates :value, inclusion: 1..99_999_999_999.00
  validates :date, date_within_boundaries: true

  FORM_FIELD_TRANSLATIONS = {
    provider_id: :provider,
    receiver_id: :receiver,
  }.freeze
end
