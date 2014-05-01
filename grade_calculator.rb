module GradeCalculator

  class Scope

    attr_reader :published_variables, :symbols

    def initialize(parent = nil)
      @parent = parent || {}
      @symbols = {}
      @published_variables = {}
    end

    def [](name)
      @symbols[name] || @parent[name]
    end

    def []=(name, value)
      @symbols[name] = value
    end
  end

  class TopLevel < Scope
    def initialize(*args)
      super

      self["min"] = Function.new(self) do |*arguments|
        arguments.min_by { |a| a.eval(self) }
      end

      self["sub"] = self["substitute"] = Function.new(self) do |target, origin|
        loop do
          target = target.eval(self)
          break if target.is_a?(Identifier)
        end
        @symbols[target.text_value] = origin.eval(self)
      end

      self["pub"] = self["publish"] = Function.new(self) do |identifier|
        @published_variables[identifier.text_value] = identifier.eval(self)
      end
    end
  end

  class Program < Treetop::Runtime::SyntaxNode
    def eval(scope)
      elements.map { |e, i| e.eval(scope) }.last
    end
  end

  module Number
    def eval(scope); text_value.to_f; end
  end

  class Identifier < Treetop::Runtime::SyntaxNode
    def eval(scope); scope[text_value]; end
  end

  module Statement
    def eval(scope)
      elements.first.eval(scope)
    end
  end

  class Space < Treetop::Runtime::SyntaxNode
    def eval(scope);  end
  end

  class Newline < Treetop::Runtime::SyntaxNode
    def eval(scope); end
  end

  class Multitive < Treetop::Runtime::SyntaxNode
    def eval(scope)
      elements.last.eval(scope)
    end
  end

  class BinaryOperation < Treetop::Runtime::SyntaxNode
    def eval(scope)
      operand_1 = elements.first
      operand_2 = elements.last
      loop do
        operand_1 = operand_1.eval(scope)
        break unless operand_1.is_a? Identifier
      end
      loop do
        operand_2 = operand_2.eval(scope)
        break unless operand_2.is_a? Identifier
      end
      operator.apply(operand_1, operand_2)
    end
  end

  class List < Treetop::Runtime::SyntaxNode
    def eval(scope)
      last = elements.last.elements.first
      last = last.eval(scope) if last.is_a?(List)
      [elements.first, *last]
    end
  end

  class FunctionCall < Treetop::Runtime::SyntaxNode
    def eval(scope)
      func = scope[name.text_value]
      args = elements[2]
      args = args.is_a?(List) ? args.elements : [args]
      func.call(scope, args)
    end
  end

  class Function
    def initialize(scope, &block)
      @scope = scope
      @body = block
    end

    def call(scope, args)
      args.reject! { |a| a.text_value.blank? }
      if args.to_a.any?
        tmp = [args.first]
        if args.length > 1
          last = args.last.elements.first
          if last.is_a?(List)
            tmp += last.eval(self)
          else
            tmp << last
          end
        end
        args = tmp
      end
      @body.call(*args)
    end
  end

  class Group < Treetop::Runtime::SyntaxNode
    def eval(scope)
      elements[1].eval(scope)
    end
  end

  class Assignment < Treetop::Runtime::SyntaxNode
    def eval(scope)
      scope[elements.first.text_value] = elements.last.eval(scope)
    end
  end
end
