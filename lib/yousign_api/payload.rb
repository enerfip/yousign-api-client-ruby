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
        unless type.blank?
          define_method("#{name}=") do |value|
            validate_type(name, value, type)
            instance_variable_set("@#{name}", value)
          end
        else
          attr_writer name
        end
      end

      def self.define_collection_writer(name, type)
        define_method("#{name}=") do |value|
          validate_types(name, value, type)
          instance_variable_set("@#{name}", value)
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
        self.class.attributes.each do |attr|
          raise "Missing required attribute '#{attr}' for '#{self.class}'" if !hsh.key?(attr) && public_send(attr).nil?
          public_send("#{attr}=", hsh[attr])
        end
      end

      private

      def validate_type(name, value, type)
        return if type.blank?
        required_kls = Object.const_get("YousignApi::Payload::#{type}")
        raise "Only '#{required_kls}' instances are accepted for '#{name}'" unless value.kind_of? required_kls
      end

      def validate_types(name, value, type)
        raise "'#{name}' only accepts array" unless value.kind_of? Array
        value.each { |v| validate_type(name, v, type) }
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
