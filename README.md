# Welcome

Example of using Openmaize authentication library in a Phoenix web application.

## Example apps

There are three branches in this repository, each of which has a different
example of using Openmaize with Phoenix.

* master - new Phoenix app after running `mix openmaize.gen.phoenixauth --confirm`
  * this has basic user authentication plus email confirmation and password resetting
  * to use this app, you need to edit the `lib/welcome/mailer.ex` file, using an email library of your choice
* basic - new Phoenix app after running `mix openmaize.gen.phoenixauth`
  * this has basic user authentication without any email confirmation
* old_admin - an older version, but one with more features
  * support for two-factor user authorization
  * authorization based on user roles

See [this guide](https://github.com/riverrun/openmaize/blob/master/phoenix_new_openmaize.md)
for more information about setting up a new app with Openmaize.
