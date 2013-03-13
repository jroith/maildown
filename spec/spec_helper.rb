$:.unshift File.expand_path("../..", __FILE__)

require 'maildown'

def fixture_path(file=nil)
  path = File.expand_path("../fixtures", __FILE__)
  path = File.join(path, file) unless file.nil?
  path
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def result_fixture(file)
  fixture("result_#{file}")
end