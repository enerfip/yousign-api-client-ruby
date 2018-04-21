require "yousign_api/client/operations_builder"

module YousignApi
  class Client
    module DSL
      module ClassMethods
        def wsdl(url, &block)
          YousignApi::Client::OperationsBuilder.new(self, url).build(block)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
