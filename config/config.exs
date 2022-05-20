import Config

config :logger, level: :debug

config :covid_pager, CovidPager.Scheduler,
  jobs: [
    # Every minute
    {"* * * * *", {CovidPager.Application, :run_task, []}}
    # {"0 0 * * *", {CovidPager.Application, :run_task, []}}
  ]
