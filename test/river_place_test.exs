defmodule RiverPlaceClientTest do
  use ExUnit.Case
  doctest RiverPlaceClient
  alias RiverPlaceClient.{TimeSlot, Booking, Facility}

  test "successful login" do
    assert {:ok, _} = RiverPlaceClient.login("test_user", "valid")
  end

  test "failed login" do
    assert :error = RiverPlaceClient.login("test_user", "invalid")
  end

  test "logout" do
    assert :ok = RiverPlaceClient.logout("valid-session-id")
  end

  test "logged_in? with valid session_id" do
    assert RiverPlaceClient.logged_in?("valid-session-id")
  end

  test "logged_in? with invalid session_id" do
    refute RiverPlaceClient.logged_in?("old-invalid-id")
  end

  test "time_slots" do
    result = RiverPlaceClient.time_slots("2016-11-12")
    assert Enum.count(result) == 4
    assert List.first(result) == %TimeSlot{
      id: 6,
      start_time: "07:00 AM",
      end_time: "08:00 AM",
      booking_id: nil,
      facility_name: "Court 1",
      status: "valid"
    }
  end

  test "create_booking sucess" do
    {:ok, booking} = RiverPlaceClient.create_booking("2016-11-12", %TimeSlot{id: 6}, "valid-session-id")
    assert booking == %Booking{
      id: 10201,
      desc: "07:00 AM  November 12 By 620602",
      facility_name: "Court 1",
      day: "2016-11-12 00:00:00",
      start: "2016-11-12 07:00:00",
      end: "2016-11-12 08:00:00",
    }
  end

  test "create_booking fail" do
    {:error, message} = RiverPlaceClient.create_booking("2016-01-01", %TimeSlot{id: 6}, "valid-session-id")
    assert message == "Session Tennis -9 08:00 AM-09:00 AM  Already been booked"
  end

  test "delete_booking success" do
    assert :ok = RiverPlaceClient.delete_booking(123, "valid-session-id")
  end

  test "delete_booking fail" do
    assert :error = RiverPlaceClient.delete_booking(666, "valid-session-id")
  end

end
