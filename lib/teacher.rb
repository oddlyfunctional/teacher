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
      unless @tree
        # This snippet was found on http://whitequark.org/blog/2011/09/08/treetop-typical-errors/
        @parser.failure_reason =~ /^(Expected .+) after/m
        error = $1.
          gsub("\n", '$NEWLINE').
          gsub("\r", '$CR')
        error += ":\n"
        line = string.lines.to_a[@parser.failure_line - 1]
        arrow = "#{'~' * (@parser.failure_column - 1)}^"
        raise error + line + arrow
      end
      @tree.eval(scope)
    end

    def parse(string)
      @parser.parse(string)
    end
  end
end
