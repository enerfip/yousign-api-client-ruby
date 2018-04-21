module YousignApi
  class Client
    module Helpers
      def config
        YousignApi
      end

      def initialize
        raise "Yousign was not configured, please use `Yousign.setup` before using Yousign API client" unless config.configured?
      end

      def base_url
        environment_dependent 'demo' => 'https://apidemo.yousign.fr:8181/',
                              'prod' => 'https://api.yousign.fr:8181/'
      end

      def iframe_url
        environment_dependent 'demo' => 'https://demo.yousign.fr/',
                              'prod' => 'https://api.yousign.fr/'
      end

      def headers
        {username: config.username,
         password: config.password,
         apikey: config.apikey}
      end

      def endpoints
        @endpoints ||= Hash.new do |h, url|
          h[url] = Savon.client(wsdl: "#{base_url}#{url}", soap_header: headers, ssl_verify_mode: :none)
        end
      end

      def objectify(hsh, operation_name)
        constantify(operation_name).new(hsh)
      end

      def constantify(sym)
        Object.const_get("YousignApi::Payload::#{camelize(sym)}")
      end

      def camelize(str)
        str.to_s.gsub(/(\A\w|_\w)/) { |m| m.upcase }.delete("_")
      end

      def environment_dependent(hsh)
        hsh.fetch(config.environment.to_s) { raise "The Yousign environment was set to #{config.environment}, but it should be either 'demo' or 'prod'" }
      end
    end
  end
end
