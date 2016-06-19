defmodule RiverPlace.TimeSlot do
  alias RiverPlace.TimeSlot

  defstruct [:id, :start_time, :end_time, :booking_id]

  def new(data) do
    time_slot_data = Map.get(data, "bookingSession")
    %TimeSlot{
      id: Map.get(time_slot_data, "id"),
      start_time: Map.get(time_slot_data, "startTime"),
      end_time: Map.get(time_slot_data, "endTime"),
      booking_id: booking_id(data)
    }
  end

  defp booking_id(data) do
    case Map.get(data, "status") do
      nil -> nil
      "valid" -> nil
      _ -> Map.get(data, "id")
    end
  end

end
