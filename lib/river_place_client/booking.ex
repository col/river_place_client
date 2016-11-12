defmodule RiverPlaceClient.Booking do
  alias RiverPlaceClient.{Booking, Facility}

  defstruct [:id, :desc, :facility, :day, :start, :end]

  def new(data) do
    %Booking{
      id: Map.get(data, "id"),
      desc: Map.get(data, "desc"),
      facility: Map.get(data, "facility") |> create_facility,
      day: Map.get(data, "day"),
      start: Map.get(data, "bookingBegin"),
      end: Map.get(data, "bookingEnd"),
    }
  end

  defp create_facility(facility) do
    %Facility{
      id: Map.get(facility, "id"),
      name: Map.get(facility, "name")
    }
  end

end
