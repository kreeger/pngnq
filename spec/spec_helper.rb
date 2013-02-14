require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'fileutils'
require 'vcr'
require 'webmock'

require 'pngnq'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/tapes'
  c.hook_into :webmock
end

RSpec.configure do |config|
  # some (optional) config here
end