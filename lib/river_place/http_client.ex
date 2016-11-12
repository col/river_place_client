defmodule RiverPlace.HttpClient do
  use HTTPoison.Base
  alias RiverPlace.HttpClient

  def login(username, password) do
    HttpClient.post!("/pub-member/login/", "username=#{username}&password=#{password}")
  end

  def logout(session_id) do
    HttpClient.post("/pub-member/logout/", "", [{"Cookie", session_id}])
  end

  def member_annoucement(session_id) do
    HttpClient.get!("/member-annoucement", [{"Cookie", session_id}])
  end

  def time_slots(year, month, day) do
    HttpClient.get!("/cms-facility-booking/status/#{year}-#{month}-#{day}/")
  end

  def create_booking(year, month, day, time_slot_id, session_id) do
    HttpClient.post!(
      "/cms-facility-booking/booking/",
      "time[]=#{year}-#{month}-#{day}&sid[]=#{time_slot_id}",
      [{"Cookie", session_id}]
    )
  end

  def delete_booking(booking_id, session_id) do
    HttpClient.post!("/cms-facility-booking/cancel/#{booking_id}/", "", [{"Cookie", session_id}])
  end

  defp process_url(url) do
    "http://www.riverplace.sg" <> url
  end

  defp process_request_headers(headers) do
    Enum.into(headers, [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end

  defp process_response_body(body) do
    case body |> Poison.decode do
      {:ok, decoded} -> decoded
      {:error, _} -> body
    end
  end

end
