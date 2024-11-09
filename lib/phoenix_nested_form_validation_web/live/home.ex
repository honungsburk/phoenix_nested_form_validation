

defmodule ExampleForm do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :field_one, :string
    embeds_one :nested_form, NestedExampleForm
  end

  def changeset(company_form, attrs \\ %{}) do
    company_form
    |> cast(attrs, [:field_one])
    |> cast_embed(:nested_form)
    |> validate_required([:field_one])
    |> validate_length(:field_one, max: 255, min: 2)
  end
end

defmodule NestedExampleForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :field_two, :string
  end

  def changeset(nested_form, attrs \\ %{}) do
    nested_form
    |> cast(attrs, [:field_two])
    |> validate_required([:field_two])
    |> validate_length(:field_two, max: 255, min: 2)
  end
end

defmodule PhoenixNestedFormValidationWeb.HomeLive do
  use PhoenixNestedFormValidationWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: %ExampleForm{} |> ExampleForm.changeset() |> to_form())}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <.form :let={f} for={@form} as={:form} phx-submit="validate" class="flex flex-col gap-4">
      <.input field={f[:field_one]} label="Errors are shown" />
      <.inputs_for :let={nested_form} field={f[:nested_form]}>
        <.input field={nested_form[:field_two]} label="Errors are not shown" />
      </.inputs_for>
      <.button>Validate</.button>
    </.form>
    """
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => form}, socket) do
    new_form =
      %ExampleForm{}
      |> ExampleForm.changeset(form)
      |> to_form(action: :validate)

    {:noreply,
      socket
      |> assign(:form, new_form)
    }
  end

end
