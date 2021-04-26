# SimpleCov
# https://github.com/simplecov-ruby/simplecov

require 'simplecov'

class LineFilter < SimpleCov::Filter
  def matches?(source_file)
    source_file.lines.count < filter_argument
  end
end

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Long files' do |src_file|
    src_file.lines.count > 100
  end
  add_group 'Multiple Files', ['app/models', 'app/controllers'] # You can also pass in an array
  add_group 'Short files', LineFilter.new(5) # Using the LineFilter class defined in Filters section above
end

# ShouldaMatchers
# https://github.com/thoughtbot/shoulda-matchers

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
    with.library :active_record
  end
end
