$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'risbn'
require 'risbn/gdata'
require 'spec'
require 'spec/autorun'

GDATA_FIXTURE_PATH = File.join(File.dirname(__FILE__), 'fixtures', 'book.xml')

Spec::Runner.configure do |config|
end
