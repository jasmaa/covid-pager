defmodule CovidPager do
  @moduledoc """
  Documentation for `CovidPager`.
  """

  alias CovidPager.Constants
  require CovidPager.Constants

  @doc """
  Go through each US state and log positive case count for current date.
  """
  def handler(request, context) when is_map(request) and is_map(context) do
    :inets.start()
    :ssl.start()

    current_datetime = DateTime.utc_now()
    range_seconds = 86400
    offset_seconds = -86400
    upper_datetime = current_datetime |> DateTime.add(range_seconds + offset_seconds)
    lower_datetime = current_datetime |> DateTime.add(-range_seconds + offset_seconds)

    Constants.us_states()
    |> Enum.each(fn us_state ->
      {:ok, {_status_line, _headers, body}} =
        :httpc.request(
          "https://jhucoronavirus.azureedge.net/api/v2/timeseries/us/cases/#{us_state}.json"
        )

      {:ok, data} = Jason.decode(body)

      Map.keys(data)
      |> Enum.each(fn calendar_date ->
        {:ok, submission} = Map.fetch(data, calendar_date)

        # Assume midnight UTC
        {:ok, submission_datetime, 0} = DateTime.from_iso8601(calendar_date <> "T00:00:00Z")

        if(
          DateTime.compare(lower_datetime, submission_datetime) == :lt and
            DateTime.compare(upper_datetime, submission_datetime) == :gt
        ) do
          raw_positives = Map.get(submission, "raw_positives")
          log_case_count(us_state, raw_positives, current_datetime)
        end
      end)
    end)

    :ok
  end

  defp log_case_count(us_state, case_count, current_datetime) do
    {:ok, _term} =
      ExAws.Cloudwatch.put_metric_data(
        [
          [
            dimensions: [
              {"State", us_state}
            ],
            metric_name: "CaseCount",
            timestamp: current_datetime,
            unit: "Count",
            value: case_count
          ]
        ],
        "CovidPager"
      )
      |> ExAws.request()
  end
end
