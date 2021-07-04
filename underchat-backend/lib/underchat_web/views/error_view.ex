defmodule UnderChatWeb.ErrorView do
  use UnderChatWeb, :view

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Endpoint não encontrado."}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Houve um erro interno no servidor =("}}
  end
end
