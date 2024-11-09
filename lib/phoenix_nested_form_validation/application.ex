defmodule PhoenixNestedFormValidation.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:phoenix_nested_form_validation, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixNestedFormValidation.PubSub},
      {Finch, name: PhoenixNestedFormValidation.Finch},
      PhoenixNestedFormValidationWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PhoenixNestedFormValidation.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PhoenixNestedFormValidationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
