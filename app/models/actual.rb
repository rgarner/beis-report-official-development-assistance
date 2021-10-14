class Actual < Transaction
  validates :value, numericality: {greater_than: 0}, unless: ->(actual) { actual.validation_context == :backfill }
end
