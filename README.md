# Chilean::Rutify

[![reviewdog](https://github.com/mihailpozarski/chilean-rutify/actions/workflows/reviewdog.yml/badge.svg?branch=main)](https://github.com/mihailpozarski/chilean-rutify/actions/workflows/reviewdog.yml)
[![rspec](https://github.com/mihailpozarski/chilean-rutify/actions/workflows/rspec.yml/badge.svg?branch=main)](https://github.com/mihailpozarski/chilean-rutify/actions/workflows/rspec.yml)

Chilean Rutify is a Ruby on Rails gem that makes rut validations and manipulation easy

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chilean-rutify'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install chilean-rutify

## Usage

You can use the available utility methods directly form the module:

```ruby
    # using an example rut '36.408.368-8'
    rut = '36408368-8'
    Chilean::Rutify.normalize_rut(rut)
    # => "364083688"
    Chilean::Rutify.format_rut(rut) # alias Chilean::Rutify.classic_rut(rut)
    # => "36.408.368-8"
    Chilean::Rutify.format_rut(rut, :dash_only) # alias Chilean::Rutify.dash_only_rut(rut)
    # => "36408368-8"
    Chilean::Rutify.format_rut(rut, :normalized) # alias Chilean::Rutify.normalize_rut(rut)
    # => "364083688"
    Chilean::Rutify.valid_rut?(rut)
    # => true
    Chilean::Rutify.valid_rut_verifier?(rut)
    # => true
    Chilean::Rutify.valid_rut_values?(rut)
    # => true
    rut = "36408368"
    Chilean::Rutify.get_verifier(rut)
    # => "8"
```

### Validator

You can also use the available validator as any other custom Rails validator:

```ruby
class Person < ActiveRecord::Base
    validates :rut, presence: true, rut: true
end
```

### Concern
Or include the new Rutifiable concern (it asumes you created a `rut` column):

```ruby
class Person < ActiveRecord::Base
    includes Chilean::Rutifiable
    self.rut_format = :classic #(optional) options: [:classic, :normalized, :dash_only, :nil] (nil = no override, default: :classic)
end
```

the last one is equivalent to:

```ruby
class Person < ActiveRecord::Base
    validates :rut, presence: true, uniqueness: { case_sensitive: false }, rut: true

    def rut=(value)
        value = Chilean::Rutify.format_rut(value)
        super(value)
    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mihailpozarski/chilean-rutify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mihailpozarski/chilean-rutify/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Chilean::Rutify project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mihailpozarski/chilean-rutify/blob/master/CODE_OF_CONDUCT.md).
