defmodule FindMeHouseDashboardWeb.DashboardComponentsTest do
  use ExUnit.Case, async: true
  import FindMeHouseDashboardWeb.DashboardComponents

  describe "status color helpers" do
    test "status_border_color/1 returns correct border colors" do
      assert status_border_color("healthy") == "border-green-500"
      assert status_border_color("degraded") == "border-yellow-500"
      assert status_border_color("down") == "border-red-500"
    end

    test "status_dot_color/1 returns correct dot colors" do
      assert status_dot_color("healthy") == "bg-green-500"
      assert status_dot_color("degraded") == "bg-yellow-500"
      assert status_dot_color("down") == "bg-red-500"
    end

    test "status_badge_color/1 returns correct badge colors" do
      assert status_badge_color("healthy") == "bg-green-100 text-green-800"
      assert status_badge_color("degraded") == "bg-yellow-100 text-yellow-800"
      assert status_badge_color("down") == "bg-red-100 text-red-800"
    end

    test "format_time/1 formats datetime correctly" do
      datetime = ~U[2023-10-05 14:30:45Z]
      assert format_time(datetime) == "14:30:45"
    end

    test "format_time/1 pads single digits with zeros" do
      datetime = ~U[2023-10-05 09:05:07Z]
      assert format_time(datetime) == "09:05:07"
    end
  end
end
