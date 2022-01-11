defmodule Web.ErrorView do
  use Web, :view

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{message: message}) do
    %{error: %{message: message}}
  end
end
