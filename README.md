# Mongoid Time With Zone

Timezones can be a developer's worst nightmare and introduce subtle bugs.

This gem provides a [Mongoid](mongoid.org) wrapper for Time objects that includes and retains the timezone name as a string.

Reading from the database will use the `ActiveSupport::TimeWithZone`'s monkey patched `#in_time_zone` (monkey patched by Mongoid) to convert the time to being a TimeWithZone.

This gem does not apply any monkey patches.

This is necessary because MongoDB can save ISO8601 formatted date strings by using a [wrapping type ISODate()](http://docs.mongodb.org/manual/core/shell-types/#date),
but these don't include the strings representing the name of the timezone. This gem stores timezone string in the database.

## Usage

with Bundler, add this gem to your `Gemfile`:

```ruby
gem 'mongoid-time_with_named_zone'
```

requiring manually:

```ruby
require 'mongoid/time_with_named_zoned'
```

Define your Mongoid models with field types of `Mongoid::TimeWithNamedZone`:

e.g.:

```ruby

class BlogPost

  field :published_at, type: Mongoid::TimeWithNamedZone
  field :body,         type: String

end

```

and assign attributes to Time instances:

```ruby
post = BlogPost.new
post.published_at = Time.now.in_time_zone('Pacific/Auckland')

```

## Testing

Run `rake spec`

## Contributing changes

Once you've made your great commits:

1. Fork time-with-zone
2. Create a topic branch - git checkout -b my_branch
3. Push to your branch - git push origin my_branch
4. Open a Pull Request to discuss your changes

That's it!

## License

See [LICENSE](LICENSE)
