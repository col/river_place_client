defmodule RiverPlaceClient do
  alias RiverPlaceClient.{Facility, Booking}
  require Logger

  @http_client Application.get_env(:river_place_client, :http_client) ||
                 RiverPlaceClient.HttpClient

  def login(username, password) do
    case @http_client.login(username, password) do
      %{body: %{"state" => "SUCCESS"}, headers: headers} ->
        session_id = find_session_id(headers)
        {:ok, session_id}

      response ->
        Logger.warn("[RiverPlaceClient] Login Failed")
        Logger.warn("Response #{inspect(response)}")
        :error
    end
  end

  def logout(session_id) do
    @http_client.logout(session_id)
    :ok
  end

  def logged_in?(session_id) do
    case @http_client.member_annoucement(session_id) do
      %{status_code: 200, body: body} ->
        !String.contains?(body, "location.href = \"/member-login\";")

      _ ->
        false
    end
  end

  # Date format: "yyyy-mm-dd"
  def time_slots(date) do
    {year, month, day} = slit_date(date)
    time_slots(year, month, day)
  end

  defp time_slots(year, month, day) do
    response = @http_client.time_slots(year, month, day)
    entity = Map.get(response.body, "entity")
    court1 = Facility.new(Map.get(entity, "t1"), "Court 1")
    court2 = Facility.new(Map.get(entity, "t2"), "Court 2")
    Enum.concat(court1.time_slots, court2.time_slots)
  end

  def create_booking(date, time_slot, session_id) do
    {year, month, day} = slit_date(date)
    create_booking(year, month, day, time_slot, session_id)
  end

  defp create_booking(year, month, day, time_slot, session_id) do
    response = @http_client.create_booking(year, month, day, time_slot.id, session_id)

    case Map.get(response.body, "state") do
      "ERROR" ->
        {:error, Map.get(response.body, "message")}

      _ ->
        {:ok, Map.get(response.body, "entity") |> List.first() |> Booking.new()}
    end
  end

  def delete_booking(booking_id, session_id) do
    case @http_client.delete_booking(booking_id, session_id) do
      %{body: %{"state" => "SUCCESS"}, status_code: 200} ->
        # Note: There doesn't seem to be a way to know if the delete operation
        # was actually successful or not.
        :ok

      _ ->
        :error
    end
  end

  defp find_session_id(headers) do
    Enum.map(headers, &elem(&1, 1))
    |> Enum.filter(&String.starts_with?(&1, "JSESSIONID"))
    |> List.first()
  end

  defp slit_date(date) do
    parts = String.split(date, "-")
    {Enum.at(parts, 0), Enum.at(parts, 1), Enum.at(parts, 2)}
  end
end
