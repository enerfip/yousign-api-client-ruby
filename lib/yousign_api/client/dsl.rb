module YousignApi
  class Client
    module DSL
      module ClassMethods

        def wsdl(enpoint_url)
          yield self
        end

        def operation(operation_name, options = {})
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
