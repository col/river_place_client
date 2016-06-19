defmodule CourtBooking do
  use HTTPoison.Base

  def court_info(year, month, day) do
    response = CourtBooking.get!("/cms-facility-booking/status/#{year}-#{month}-#{day}/")
    entity = Map.get(response.body, "entity")
    court1 = Facility.new(Map.get(entity, "t1"), "Court 1")
    court2 = Facility.new(Map.get(entity, "t2"), "Court 2")
    [court1, court2]
  end

  def book_court(year, month, day, time_slot) do
    response = CourtBooking.post!(
      "/cms-facility-booking/booking/",
      "time[]=#{year}-#{month}-#{day}&sid[]=#{time_slot.id}"
    )
    case Map.get(response.body, "state") do
      "ERROR" -> :error
      _ -> :ok
    end
  end

  def delete_booking(booking_id) do
    case CourtBooking.post!("/cms-facility-booking/cancel/#{booking_id}/", "") do
      %{status_code: 200, body: body} ->
        # Note: There doesn't seem to be a way to know if the delete operation
        # was actually successful or not.
        :ok
      _ -> :error
    end
  end

  defp process_url(url) do
    "http://www.riverplace.sg" <> url
  end

  defp process_request_headers(headers) do
    session_id = Agent.get(:login_cookie, fn(s) -> s end)
    Enum.into(headers, [
      {"Cookie", session_id},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end

  defp process_response_body(body) do
    body |> Poison.decode!
  end

end
