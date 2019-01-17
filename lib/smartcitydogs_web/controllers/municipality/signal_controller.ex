defmodule SmartcitydogsWeb.Municipality.SignalController do
  use SmartcitydogsWeb, :controller
  alias Smartcitydogs.{Signal, Repo, SignalFilter}
  import Ecto.Query

  action_fallback(SmartcitydogsWeb.FallbackController)

  def index(conn, params) do
    page =
      Signal
      |> order_by(desc: :inserted_at)
      |> preload([:signal_type, :signal_category, :signal_comments, :signal_likes])

    filter_changeset =
      if params["signal_filters"] != nil do
        SignalFilter.changeset(%SignalFilter{}, params["signal_filters"])
      else
        SignalFilter.changeset(%SignalFilter{}, %{})
      end

    page =
      if params["signal_filters"]["signal_type_id"] &&
           params["signal_filters"]["signal_type_id"] != "" do
        page |> where([p], p.signal_type_id == ^params["signal_filters"]["signal_type_id"])
      else
        page
      end

    page =
      if params["signal_filters"]["signal_category_id"] &&
           params["signal_filters"]["signal_category_id"] != "" do
        page
        |> where(
          [p],
          p.signal_category_id == ^params["signal_filters"]["signal_category_id"]
        )
      else
        page
      end

    pagination_params = [
      {:signal_filters,
       [
         {:signal_type_id, params["signal_filters"]["signal_type_id"]},
         {:signal_category_id, params["signal_filters"]["signal_category_id"]}
       ]}
    ]

    page = Repo.paginate(page, params)

    render(conn, "index.html",
      params: params,
      pagination_params: pagination_params,
      signals: page.entries,
      page: page,
      filter_changeset: filter_changeset
    )
  end
end
