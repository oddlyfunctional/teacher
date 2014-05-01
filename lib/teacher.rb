require 'teacher/version'

require 'treetop'

require 'teacher/scope'
require 'teacher/function'
require 'teacher/nodes'

Treetop.load("grammar/teacher")

module Teacher

  class Base

    attr_accessor :scope

    def initialize
      @parser = TeacherParser.new
    end

    def run(string)
      @scope = TopLevel.new
      @tree = parse(string)
      @tree.eval(scope)
    end

    def parse(string)
      @parser.parse(string)
    end
  end
end
