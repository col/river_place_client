defmodule RiverPlaceClient.Booking do
  alias RiverPlaceClient.Booking

  defstruct [:id, :desc, :facility_name, :day, :start, :end]

  def new(data) do
    %Booking{
      id: Map.get(data, "id"),
      desc: Map.get(data, "desc"),
      facility_name: Map.get(data, "facility") |> Map.get("name"),
      day: Map.get(data, "day"),
      start: Map.get(data, "bookingBegin"),
      end: Map.get(data, "bookingEnd")
    }
  end
end
