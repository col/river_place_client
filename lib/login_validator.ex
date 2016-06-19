defmodule LoginValidator do
  use HTTPoison.Base

  def validate do
    case LoginValidator.get!("/member-annoucement") do
      %{status_code: 200, body: body} ->
        !String.contains?(body, "location.href = \"/member-login\";")
      response ->
        false
    end
  end

  defp process_url(url) do
    "http://www.riverplace.sg" <> url
  end

  defp process_request_headers(headers) do
    session_id = Agent.get(:login_cookie, fn(s) -> s end)
    Enum.into(headers, [{"Cookie", session_id}])
  end

end
