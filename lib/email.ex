defmodule Welcome.Email do
  use Bamboo.Phoenix, view: Welcome.EmailView

  alias Welcome.Mailer

  @moduledoc """
  A module for sending emails

  Our emails can be sent as pure text, HTML or even as an application view, but
  to keep it simple we will use text only in the examples below.
  Check the Phoenix Framework docs (http://www.phoenixframework.org/docs/sending-email)
  for more details on how to send other types of emails
  """

  @doc """
  An email with a confirmation link in it.
  """
  def ask_confirm(email, link) do
    new_email()
    |> to(email)
    |> from("welcome@example.com")
    |> subject("Confirm your account - Welcome Example")
    |> text_body("Confirm your Welcome Example email here http://www.example.com/sessions/confirm?#{link}")
    |> Mailer.deliver_now
  end

  @doc """
  An with a link to reset the password.
  """
  def ask_reset(email, link) do
    new_email()
    |> to(email)
    |> from("welcome@example.com")
    |> subject("Reset your password - Welcome Example")
    |> text_body("Reset your password at http://www.example.com/password_resets/edit?#{link}")
    |> Mailer.deliver_now
  end

  @doc """
  An email acknowledging that the account has been successfully confirmed.
  """
  def receipt_confirm(email) do
    new_email()
    |> to(email)
    |> from("welcome@example.com")
    |> subject("Confirmed account - Welcome Example")
    |> text_body("Your account has been confirmed!")
    |> Mailer.deliver_now
  end
end
