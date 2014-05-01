require 'treetop'

require 'scope'
require 'function'
require 'nodes'

module Teacher

  attr_accessor :scope

  def initialize(input)
    @tree = parse(input)
    @scope = TopLevel.new
  end

  def run
    @tree.eval(scope)
  end

  def parse(string)
    @parser ||= TeacherParser.new
    @parser.parse(string)
  end
end
