defmodule RiverPlaceClient.HttpClientMock do

  def login(_, "valid") do
    %{
      body: %{"state" => "SUCCESS"},
      status_code: 200,
      headers: [{"JSESSIONID", "valid-session-id"}]
    }
  end

  def login(_, _) do
    %{ body: %{"state" => "ERROR"} }
  end

  def logout("valid-session-id") do
    %{ body: %{"state" => "SUCCESS"}, status_code: 200 }
  end

  def logout(_) do
    %{ body: %{"state" => "ERROR"} }
  end

  def member_annoucement("valid-session-id") do
    %{status_code: 200, body: ""}
  end

  def member_annoucement(_) do
    %{status_code: 200, body: "location.href = \"/member-login\";"}
  end

  def time_slots("2016", "11", "12") do
    body = File.read!("test/data/time_slots_response.json")
    %{ body: Poison.decode!(body), status_code: 200 }
  end

  def time_slots(_, _, _) do
    %{ body: %{"state" => "ERROR"} }
  end

  def create_booking("2016", "11", "12", _, "valid-session-id") do
    body = File.read!("test/data/booking_success_response.json")
    %{ body: Poison.decode!(body), status_code: 200 }
  end

  def create_booking(_, _, _, _, _) do
    %{
      body: %{
        "state" => "ERROR",
        "message" => "Session Tennis -9 08:00 AM-09:00 AM  Already been booked"
      },
      status_code: 200
    }
  end

  def delete_booking(123, "valid-session-id") do
    %{ body: %{"state" => "SUCCESS"}, status_code: 200 }
  end

  def delete_booking(_, _) do
    %{ body: %{"state" => "ERROR"}, status_code: 200 }
  end

end
