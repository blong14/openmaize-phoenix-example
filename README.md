# Welcome

NOTE: if you are using Phoenix 1.3, take a look at
[Phauxth](https://github.com/riverrun/phauxth), which is designed
with Phoenix 1.3 in mind and is also a lot more extensible.

Example of using Openmaize authentication library in a Phoenix web application.

## Example apps

There are three branches in this repository, each of which has a different
example of using Openmaize with Phoenix.

The master and basic branches are examples of new Phoenix apps set up with Openmaize according
to [this guide](https://github.com/riverrun/openmaize/wiki/Openmaize-with-a-new-phoenix-project).

* master - new Phoenix app after running `mix openmaize.phx --confirm` and adding an email module
  * this has basic user authentication plus email confirmation and password resetting
  * to use this app, you need to edit the `lib/welcome/mailer.ex` file, using an email library of your choice
* basic - new Phoenix app after running `mix openmaize.phx`
  * this has basic user authentication without any email confirmation
* old_admin - an older version, but one with more features
  * support for two-factor user authorization
  * authorization based on user roles

See [this guide](https://github.com/riverrun/openmaize/blob/master/phoenix_new_openmaize.md)
for more information about setting up a new app with Openmaize.
