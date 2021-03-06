require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'exposition'

class Treetop::Runtime::SyntaxNode 
  def method_missing(method, *args)
    raise "Node representing '#{text_value}' does not respond to '#{method}'"
  end
end

class Test::Unit::TestCase
  def parse(input)
    result = @parser.parse(input)
    unless result
      puts "\n" << @parser.terminal_failures.join("\n") << "\n"
    end
    assert !result.nil?
    result
  end
  
  def prepare_content_for_parse(content)
    string = content.gsub(/\r\n/, "\n")
    string = string.split("\n").map do |line|
      line.gsub(/\s+$/, '')
    end.join("\n")
    "\n#{string}\n"
  end
  
  def blank_line
    "\n * \n "
  end
  
  def parse_file(filename)
    filename = filename == 'comment' ? 'comment' : "#{filename}.h"
    path = File.expand_path(File.join(File.dirname(__FILE__), "samples", filename))
    file = prepare_content_for_parse(File.read(path))
    parse(file)
  end
  
  def assert_parsed(input)
    assert !parse(input).nil?
  end
  
  def assert_file_parsed(filename)
    assert !parse_file(filename).nil?
  end
  
  def assert_not_parsed(input)
    assert @parser.parse(input).nil?
  end
end

##
# test/spec/mini 3
# http://gist.github.com/25455
# chris@ozmm.org
# file:lib/test/spec/mini.rb
#
def context(*args, &block)
  return super unless (name = args.first) && block
  require 'test/unit'
  klass = Class.new(defined?(ActiveSupport::TestCase) ? ActiveSupport::TestCase : Test::Unit::TestCase) do
    def self.test(name, &block) 
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end
    def self.xtest(*args) end
    def self.setup(&block) define_method(:setup, &block) end
    def self.teardown(&block) define_method(:teardown, &block) end
  end
  (class << klass; self end).send(:define_method, :name) { name.gsub(/\W/,'_') }
  klass.class_eval &block
end