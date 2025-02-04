require 'rubygems'

# Rails will log to irb
if defined?(Logger) && ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
end
