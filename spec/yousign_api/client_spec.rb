require "spec_helper"

RSpec.describe YousignApi::Client do
  before do
    YousignApi.setup do |config|
      config.username = "user"
      config.password = "password"
      config.apikey = "somapik"
      config.environment = "demo"
    end
  end

  describe "#connect" do
    it "sends a connect command to the correct endpoint" do
      connect_double = double(call: true)
      expect(Savon).to receive(:client).with(
        wsdl: "https://apidemo.yousign.fr:8181/AuthenticationWS/AuthenticationWS?wsdl",
        soap_header: {username: "user", password: "password", apikey: "somapik"},
        ssl_verify_mode: :none
      ).and_return connect_double
      described_class.new.connect
    end
  end
end
