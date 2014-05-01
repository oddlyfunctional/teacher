module Teacher

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
end
