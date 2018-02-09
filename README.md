# Frodo

![frodo](https://uproxx.files.wordpress.com/2015/10/frodo.jpg?quality=100&w=650&h=400)

Gandalf... gemified

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'frodo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install frodo

## Usage

### Pundit Integration
Frodo's authorization system of choice is Pundit.  As such, you get a `FrodoPolicy` for free.  Just make your `ApplicationPolicy` inherit from it:

```
  ApplicationPolicy < Frodo::Pundit::FrodoPolicy
```

`FrodoPolicy` gives the inheriting policy access to these methods:
* `initialize`
* `has_privilege?`
* `salido_pos?`
* `owner?`
* `client_application_name`

### FrodoHelpers

`include Helpers:: GeneralHelpers`

Including this line puts the following methods in scope:
* `acl` - Parsed Access Control List (ACL) from Gandalf
* `current_application` - The application associated with the token used to retrieve the ACL from Gandalf
* `current_user` - The user (if any) associated with the token used to retrieve the ACL from Gandalf

## Grape Integration
1. Create a new initializer with this line or add to a current initializer: `Grape::API.extend Frodo::Extension`
2. Then add this to your API class `use Frodo::Federate`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/salido/frodo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Frodo project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/frodo/blob/master/CODE_OF_CONDUCT.md).
