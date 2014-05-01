module Teacher
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
end
