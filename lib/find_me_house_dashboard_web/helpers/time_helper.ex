defmodule FindMeHouseDashboardWeb.Helpers.TimeHelper do

  # Convert UTC datetime to local timezone
  def to_local_time(utc_datetime, timezone) do
    Timex.to_datetime(utc_datetime, timezone)
  end

  # Just the time part
  def format_time_only(datetime) do
    Timex.format!(datetime, "{h24}:{m}")
  end
end
