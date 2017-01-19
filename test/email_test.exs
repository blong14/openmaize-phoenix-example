defmodule Welcome.EmailTest do
  use ExUnit.Case
  use Bamboo.Test

  setup do
    email = "fred@mail.com"
    {_, link} = Openmaize.ConfirmEmail.gen_token_link(email)
    {:ok, %{email: email, link: link}}
  end

  test "sends confirmation request email", %{email: email, link: link} do
    sent_email = Welcome.Email.ask_confirm(email, link)
    assert sent_email.subject =~ "Confirm your account"
    assert sent_email.text_body =~ "confirm_email?email=fred%40mail.com&key="
    assert_delivered_email Welcome.Email.ask_confirm(email, link)
  end

  test "sends reset password request email", %{email: email, link: link} do
    sent_email = Welcome.Email.ask_reset(email, link)
    assert sent_email.subject =~ "Reset your password"
    assert sent_email.text_body =~ "edit?email=fred%40mail.com&key="
    assert_delivered_email Welcome.Email.ask_reset(email, link)
  end

  test "sends receipt confirmation email", %{email: email} do
    sent_email = Welcome.Email.receipt_confirm(email)
    assert sent_email.subject =~ "Confirmed account"
    assert_delivered_email Welcome.Email.receipt_confirm(email)
  end
end
