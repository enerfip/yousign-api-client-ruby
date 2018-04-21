module YousignApi
  module Payload
    class Base
      def self.attributes
        @attributes ||= []
      end

      def self.attribute(name, default: nil, type: nil)
        attributes << name
        define_writer(name, type)
        define_reader(name, default)
      end


      def self.collection(name, type: nil)
        attributes << name
        define_collection_writer(name, type)
        define_reader(name, [])
      end

      def self.define_writer(name, type)
        unless type.nil?
          define_method("#{name}=") do |value|
            instance_variable_set("@#{name}", objectify(name, value, type))
          end
        else
          attr_writer name
        end
      end

      def self.define_collection_writer(name, type)
        define_method("#{name}=") do |value|
          instance_variable_set("@#{name}", objectify_collection(name, value, type))
        end
      end

      def self.define_reader(name, default)
        define_method("#{name}") do
          instance_variable_get("@#{name}") || default
        end
      end

      def to_payload
        self.class.attributes.each_with_object({}) do |key, memo|
          value = public_send(key)
          memo[key.to_sym] = payloadify(value)
        end
      end

      def initialize(hsh)
        raise "Payload object needs a hash" unless hsh.respond_to?(:key?) && hsh.respond_to?(:[])
        self.class.attributes.each do |attr|
          raise "Missing required attribute '#{attr}' for '#{self.class}'" if !hsh.key?(attr) && public_send(attr).nil?
          public_send("#{attr}=", hsh[attr])
        end
      end

      private

      def objectify(name, value, type)
        return value if type.nil?
        type_kls = Object.const_get("YousignApi::Payload::#{type}")
        type_kls.new(value)
      rescue StandardError => e
        raise $!, "Field #{name}: #{$!}", $!.backtrace
      end

      def objectify_collection(name, value, type)
        raise "'#{name}' only accepts array. #{value.inspect} given instead" unless value.kind_of? Array
        value.map { |v| objectify(name, v, type) }
      end

      def payloadify(value)
        if value.kind_of? Array
          value.map { |v| payloadify(v) }
        else
          value.respond_to?(:to_payload) ? value.to_payload : value
        end
      end
    end
  end
end
