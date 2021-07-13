class Activity
  class RodaIdentifierGenerator
    def initialize(parent_activity)
      @parent_activity = parent_activity
    end

    def generate
      [
        parent_activity.roda_identifier,
        component_identifier,
      ].join("-")
    end

    private

    def component_identifier
      Nanoid.generate(size: 7, alphabet: characters_to_use)
    end

    def characters_to_use
      # This contains a string of all alphanumeric characters,
      # minus `0`, `1`, `I` and `O`, which can be easily
      # confused.
      "23456789ABCDEFGHJKLMNPQRSTUVWXYZ"
    end

    attr_reader :parent_activity
  end
end
