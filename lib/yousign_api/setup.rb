module YousignApi
  module Setup
    module ClassMethods
      @@configured = false
      def configured?
        @@configured
      end

      def setup
        yield self
        @@configured = true
      end

      def setup_defaults defaults
        defaults.each do |key, value|
          class_variable_set("@@#{key}", value)
          class_eval(<<-EOS, __FILE__, __LINE__ + 1)
            def self.#{key}
              @@#{key}
            end

            def self.#{key}=(new_val)
              @@#{key} = new_val
            end
          EOS
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
