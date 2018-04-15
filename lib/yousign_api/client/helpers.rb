module YousignApi
  class Client
    module Helpers
      def config
        YousignApi
      end

      def initialize
        raise "Yousign was not configured, please use `Yousign.setup` before using Yousign API client" unless config.configured?
      end

      def endpoint
        {
          'demo' => 'https://apidemo.yousign.fr:8181/',
          'prod' => 'https://api.yousign.fr:8181/'
        }.fetch(config.environment.to_s) { raise "The Yousign environment was set to #{config.environment}, but it should be either 'demo' or 'prod'" }
      end

      def urliframe
        {
          'demo' => 'https://demo.yousign.fr/',
          'prod' => 'https://api.yousign.fr/'
        }.fetch(config.environment.to_s) { raise "The Yousign environment was set to '#{config.environment}', but it should be either 'demo' or 'prod'" }
      end

      def headers
        {username: config.username,
         password: config.password,
         apikey: config.apikey}
      end

      def clientauth
        @clientauth ||= Savon.client(wsdl: urlauth, soap_header: headers, ssl_verify_mode: :none)
      end

      def signature_init(payload)
        clientsign.call(:init_cosign, message: payload.to_payload)
      end
    end
  end
end

