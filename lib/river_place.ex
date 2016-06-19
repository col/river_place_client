defmodule RiverPlace do
  use HTTPoison.Base
  alias RiverPlace.{Facility, TimeSlot}

  def start(:normal, []) do
    Agent.start_link(fn -> "" end, name: :login_cookie)
  end

  def login(username, password) do
    case RiverPlace.post!("/pub-member/login/", "username=#{username}&password=#{password}") do
      %{body: %{"state" => "SUCCESS"}, headers: headers} ->
        store_cookie(headers)
        :ok
      _ ->
        :error
    end
  end

  def logout do
    RiverPlace.post("/pub-member/logout/", "")
    Agent.update(:login_cookie, fn(_) -> "" end)
    :ok
  end

  def logged_in? do
    case RiverPlace.get!("/member-annoucement") do
      %{status_code: 200, body: body} ->
        !String.contains?(body, "location.href = \"/member-login\";")
      response ->
        false
    end
  end

  def time_slots(date) do
    {year, month, day} = slit_date(date)
    time_slots(year, month, day)
  end

  defp time_slots(year, month, day) do
    response = RiverPlace.get!("/cms-facility-booking/status/#{year}-#{month}-#{day}/")
    entity = Map.get(response.body, "entity")
    court1 = Facility.new(Map.get(entity, "t1"), "Court 1")
    court2 = Facility.new(Map.get(entity, "t2"), "Court 2")
    Enum.concat(court1.time_slots, court2.time_slots)
  end

  def create_booking(date, time_slot) do
    {year, month, day} = slit_date(date)
    create_booking(year, month, day, time_slot)
  end

  defp create_booking(year, month, day, time_slot) do
    response = RiverPlace.post!(
      "/cms-facility-booking/booking/",
      "time[]=#{year}-#{month}-#{day}&sid[]=#{time_slot.id}"
    )
    case Map.get(response.body, "state") do
      "ERROR" -> :error
      _ -> :ok
    end
  end

  def delete_booking(booking_id) do
    case RiverPlace.post!("/cms-facility-booking/cancel/#{booking_id}/", "") do
      %{status_code: 200, body: body} ->
        # Note: There doesn't seem to be a way to know if the delete operation
        # was actually successful or not.
        :ok
      _ -> :error
    end
  end

  defp store_cookie(headers) do
    session_id = find_session_id(headers)
    Agent.update(:login_cookie, fn(_) -> session_id end)
  end

  def find_session_id(headers) do
    Enum.map(headers, &elem(&1,1))
      |> Enum.filter(&String.starts_with?(&1, "JSESSIONID"))
      |> List.first
  end

  defp process_url(url) do
    "http://www.riverplace.sg" <> url
  end

  defp process_request_headers(headers) do
    session_id = Agent.get(:login_cookie, &(&1))
    Enum.into(headers, [
      {"Cookie", session_id},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end

  defp process_response_body(body) do
    case body |> Poison.decode do
      {:ok, decoded} -> decoded
      {:error, _} -> body
    end
  end

  defp slit_date(date) do
    parts = String.split(date, "-")
    {Enum.at(parts, 0), Enum.at(parts, 1), Enum.at(parts, 2)}
  end

end
