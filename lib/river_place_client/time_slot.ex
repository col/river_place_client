defmodule RiverPlaceClient.TimeSlot do
  alias RiverPlaceClient.TimeSlot

  defstruct [:id, :start_time, :end_time, :booking_id, :facility_name, :status]

  def new(data, facility_name) do
    time_slot_data = Map.get(data, "bookingSession")

    %TimeSlot{
      id: Map.get(time_slot_data, "id"),
      start_time: Map.get(time_slot_data, "startTime"),
      end_time: Map.get(time_slot_data, "endTime"),
      booking_id: booking_id(data),
      facility_name: facility_name,
      status: Map.get(data, "status")
    }
  end

  def available?(time_slot) do
    time_slot.status == "valid" && time_slot.booking_id == nil
  end

  def available(time_slots) do
    Enum.filter(time_slots, fn t -> TimeSlot.available?(t) end)
  end

  def for_time(time_slots, time) do
    Enum.filter(time_slots, fn t -> t.start_time == time end)
  end

  defp booking_id(data) do
    case Map.get(data, "status") do
      nil -> nil
      "valid" -> nil
      _ -> Map.get(data, "id")
    end
  end
end
