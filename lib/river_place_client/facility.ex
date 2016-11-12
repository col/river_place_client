defmodule RiverPlaceClient.Facility do
  alias RiverPlaceClient.{Facility, TimeSlot}

  defstruct [:id, :name, :time_slots]

  def new(data, name) do
    summary = Map.get(data, "dailySummaries") |> List.first
    bookingData = Map.get(summary, "facilityBookings")
    %Facility{
      id: Map.get(data, "id"),
      name: name,
      time_slots: Enum.map(bookingData, fn(d) -> TimeSlot.new(d, name) end)
    }
  end

end
