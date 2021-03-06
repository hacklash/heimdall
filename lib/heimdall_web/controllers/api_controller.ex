defmodule HeimdallWeb.ApiController do
  use HeimdallWeb, :controller
  import Plug.Conn


  # UPC-A numbers should be 11 digits and the check digit
  # todo: decide how to handle ill-sized input

  # this route takes one upc, and returns the upc with the check digit added
  # http://0.0.0.0:4000/api/add_check_digit/1234
  def add_check_digit(conn, params) do
    check_digit_with_upc = _calculate_check_digit(params["upc"])
    _send_json(conn, 200, check_digit_with_upc)
  end

  # this route takes a comma separated list and should add a check digit to each element
  # http://0.0.0.0:4000/api/add_a_bunch_of_check_digits/12345,233454,34341432
  def add_a_bunch_of_check_digits(conn, params) do
    check_digits_with_upc = String.split(params["upcs"], ",")
    |> Enum.map((fn upc -> _calculate_check_digit(upc) end))

    _send_json(conn, 200, check_digits_with_upc)
  end

  # these are private methods
  defp _calculate_check_digit(upc) do
    digits = upc
    |> String.to_integer()
    |> Integer.digits()
    |> Enum.reverse

    odds_sum = digits
    |> Enum.take_every(2)
    |> Enum.sum()

    evens_sum = digits
    |> Enum.drop(1)
    |> Enum.take_every(2)
    |> Enum.sum()

    check_digit = 10 - ((odds_sum * 3 + evens_sum) |> Integer.mod(10))
    |> Integer.mod(10)

    "#{upc}#{check_digit}"
  end

  # this is a thing to format your responses and return json to the client
  defp _send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Poison.encode!(body))
  end

end
