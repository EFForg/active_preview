# ActivePreview
active_preview is a Ruby on Rails plugin that makes it easy to create previews of updates to records. The previews don't interact with the database but otherwise behave like ActiveRecord objects.

## Usage
To preview a model, first run the generator:
```bash
$ rails generate active_preview:preview --model MyModel
```
This will create `my_model_preview.rb` in `app/previews`. If you have methods that touch the database in your model that need to be used with previewed data, override them there. 

Next, add the `#preview` method to your model:
```ruby
class MyModel < ActiveRecord::Base
  include ActivePreview::Previewing
end
```

Now you can pass an attribute hash or `ActionController::Parameters` object to `my_model.preview` to get a preview object with updated attributes that behaves exactly like your model.

For models with associations, run the generator for each associated model and add `include ActivePreview::Previewing` to each model class.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'active_preview'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_preview
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
