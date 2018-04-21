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
      expect_request(
        wsdl: "AuthenticationWS/AuthenticationWS?wsdl",
        method: :connect,
        args: no_args
      )
      described_class.new.connect
    end
  end

  describe "#get_complete_archive" do
    it "sends a get_complete_archive to the correct endpoint" do
      expect_request(
        wsdl: "ArchiveWS/ArchiveWS?wsdl",
        method: :get_complete_archive,
        args: { iua: 1 }
      )
      described_class.new.get_complete_archive(iua: 1)
    end
  end

  def expect_request(wsdl:, method:, args:)
    connect_double = double(call: true)
    expect(Savon).to receive(:client).with(
      wsdl: "https://apidemo.yousign.fr:8181/#{wsdl}",
      soap_header: {username: "user", password: "password", apikey: "somapik"},
      ssl_verify_mode: :none
    ).and_return connect_double
    if args == no_args
      expect(connect_double).to receive(:call).with(method)
    else
      expect(connect_double).to receive(:call).with(method, args)
    end
  end
end
