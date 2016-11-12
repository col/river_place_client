# River Place Facility Booking API

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add river_place to your list of dependencies in `mix.exs`:

        def deps do
          [{:river_place, "~> 0.0.1"}]
        end

  2. Ensure river_place is started before your application:

        def application do
          [applications: [:river_place]]
        end

## Example

```
iex -S mix

# Login
iex> {:ok, session_id} = RiverPlace.login("620602T", "jabba007")

# Check Login
iex> RiverPlace.logged_in?(session_id)
true

# Get all time slots for a day
iex> RiverPlace.time_slots("2016-11-12")
[%RiverPlace.TimeSlot{booking_id: nil, end_time: "08:00 AM",
  facility_name: "Court 1", id: 6, start_time: "07:00 AM", status: "valid"},
  %RiverPlace.TimeSlot{booking_id: nil, end_time: "09:00 AM",
  facility_name: "Court 1", id: 7, start_time: "08:00 AM", status: "valid"}
  ...
]

# Get available time slots for a specific time
iex> alias RiverPlace.TimeSlot
iex> first_available = RiverPlace.time_slots("2016-11-12") |> TimeSlot.available |> TimeSlot.for_time("08:00 AM") |> List.first
%RiverPlace.TimeSlot{booking_id: nil, end_time: "09:00 AM",
  facility_name: "Court 1", id: 7, start_time: "08:00 AM", status: "valid"}

# Book a court
iex> {:ok, booking} = RiverPlace.create_booking("2016-11-12", first_available, session_id)
{:ok,
 %RiverPlace.Booking{day: "2016-11-12 00:00:00",
  desc: "08:00 AM  November 11 By 620602", end: "2016-11-12 09:00:00",
  facility: %RiverPlace.Facility{id: 4, name: "Tennis Court 1",
   time_slots: nil}, id: 10206, start: "2016-11-12 08:00:00"}}

# Delete a booking
iex> RiverPlace.delete_booking(booking.id, session_id)
:ok

# Logout
iex> RiverPlace.logout(session_id)
:ok

# Confirm Logout
ie> RiverPlace.logged_in?(session_id)
false

```
