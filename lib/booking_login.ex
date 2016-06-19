defmodule BookingLogin do
  use HTTPoison.Base

  def login(username, password) do
      BookingLogin.post!("/pub-member/login/", "username=#{username}&password=#{password}")
        |> handle_login
  end

  defp handle_login(%{body: "SUCCESS", headers: headers}) do
    store_cookie(headers)
    :ok
  end

  defp handle_login(_) do
    :error
  end

  def logout() do
    BookingLogin.post!("/pub-member/logout/", "")
    Agent.update(:login_cookie, fn(_) -> "" end)
    :ok
  end

  defp store_cookie(headers) do
    session_id = Enum.filter(headers, fn(h) ->
      case h do
        {"Set-Cookie", value} -> String.starts_with?(value, "JSESSIONID")
        _ -> false
      end
    end) |> List.first |> elem(1)
    Agent.start_link(fn -> "" end, name: :login_cookie)
    Agent.update(:login_cookie, fn(_) -> session_id end)
  end

  defp process_url(url) do
    "http://www.riverplace.sg" <> url
  end

  defp process_request_headers(headers) do
    Enum.into(headers, [{"Content-Type", "application/x-www-form-urlencoded"}])
  end

  defp process_response_body(body) do
    body |> Poison.decode! |> Map.get("state")
  end

end
