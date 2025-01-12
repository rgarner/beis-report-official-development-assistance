require "rails_helper"

RSpec.describe Activity::HistoricalEventsGrouper do
  let(:user1) { create(:delivery_partner_user, email: "john@example.com") }
  let(:user2) { create(:delivery_partner_user, email: "fred@example.com") }
  let(:activity) { create(:project_activity) }

  let!(:event1) do
    HistoricalEvent.create(
      activity: activity,
      trackable: activity,
      reference: "Update to Activity programme_status",
      user: user1,
      created_at: Time.zone.parse("02-Jul-2021 12:08:00")
    )
  end
  let!(:event2) do
    HistoricalEvent.create(
      activity: activity,
      trackable: activity,
      reference: "Update to Activity programme_status",
      user: user1,
      created_at: Time.zone.parse("02-Jul-2021 12:08:10")
    )
  end

  let!(:event3) do
    HistoricalEvent.create(
      activity: activity,
      trackable: activity,
      reference: "Import from CSV",
      user: user2,
      created_at: Time.zone.parse("07-Jul-2021 10:45:20")
    )
  end
  let!(:event4) do
    HistoricalEvent.create(
      activity: activity,
      trackable: activity,
      reference: "Import from CSV",
      user: user2,
      created_at: Time.zone.parse("07-Jul-2021 10:45:30")
    )
  end

  it "groups events using a combination of reference, user.email and time, newest first" do
    expect(Activity::HistoricalEventsGrouper.new(activity: activity).call).to eq(
      {
        {
          reference: "Import from CSV",
          user: "fred@example.com",
          timestamp: "07 Jul 2021 at 10:45",
        } => [event4, event3],

        {
          reference: "Update to Activity programme_status",
          user: "john@example.com",
          timestamp: "02 Jul 2021 at 12:08",
        } => [event2, event1],
      }
    )
  end
end
