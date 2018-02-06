defmodule HeimdallWeb.ApiControllerTest do
  use HeimdallWeb.ConnCase

  test "add_check_digit", %{conn: conn} do
    conn = get conn, "/api/add_check_digit/72641217542"
    assert json_response(conn, 200) =~ "726412175425"

    conn = get conn, "/api/add_check_digit/7725272730"
    assert json_response(conn, 200) =~ "77252727306"
  end

  test "add_a_bunch_of_check_digits", %{conn: conn} do
      conn = get conn, "/api/add_a_bunch_of_check_digits/72641217542,7725272730"
      assert json_response(conn, 200) == ["726412175425","77252727306"]
  end
end
