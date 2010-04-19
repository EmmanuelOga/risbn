$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'risbn'
require 'risbn/gdata'
require 'spec'
require 'spec/autorun'

FIXTURE = lambda { |f| File.read File.join(File.dirname(__FILE__), 'fixtures', f) }

Spec::Runner.configure do |config|
end
