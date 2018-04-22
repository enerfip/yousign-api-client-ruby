require "savon"

module YousignApi
  class Client
    class OperationsBuilder
      attr_reader :client_class, :endpoint_url, :client

      def initialize(client_class, endpoint_url)
        @client_class = client_class
        @endpoint_url = endpoint_url
      end

      def build(block)
        instance_eval(&block)
      end

      def operation(operation_name, options = {})
        local_endpoint_url = endpoint_url
        client_class.class_eval do
          if options.key?(:payload) && !options[:payload]
            define_method(operation_name) do
              endpoints[local_endpoint_url].call(operation_name)
            end
          else
            define_method(operation_name) do |payload_hash|
              endpoints[local_endpoint_url].call(operation_name, message: objectify(payload_hash, operation_name).to_payload)
            end
          end
        end
      end
    end
  end
end
