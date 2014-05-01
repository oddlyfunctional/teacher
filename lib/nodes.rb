module Teacher
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
