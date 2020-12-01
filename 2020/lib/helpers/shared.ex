defmodule Helpers.Shared do
  def calculate_year do
    today = Date.utc_today
    if today.month < 12 do
      # It's before december so the newest advent calendar is not out yet, so use last year's by default
      today.year-1
    else
      today.year
    end
  end
end
