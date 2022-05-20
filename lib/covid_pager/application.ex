defmodule CovidPager.Application do
  use Application

  alias CovidPager.Constants
  require CovidPager.Constants

  def start(_type, _args) do
    children = [
      CovidPager.Scheduler
    ]

    opts = [strategy: :one_for_one, name: CovidPager.Application]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Runs scheduled task. Task goes through each US state and sees logs positive case count for current date.
  """
  def run_task do
    :inets.start()
    :ssl.start()

    current_datetime = DateTime.utc_now()
    offset_seconds = 86400
    upper_datetime = current_datetime |> DateTime.add(offset_seconds)
    lower_datetime = current_datetime |> DateTime.add(-offset_seconds)

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
          IO.inspect(us_state)
          IO.inspect(submission_datetime)
          IO.inspect(submission)
        end
      end)
    end)
  end
end
