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

  describe "init_cosign" do
    it "inits a cosign" do
      expect_request(
        wsdl: "CosignWS/CosignWS?wsdl",
        method: :init_cosign,
        args: {
          lstCosignedFile: [{
            name: "fixture.txt",
            content: "ZHVtbXkgY29udGVudAo=\n",
            visibleOptions: [{
              visibleSignaturePage: 1,
              isVisibleSignature: "True",
              visibleRectangleSignature: "0,39,99,0",
              mail: ""
            }]
          }],
          lstCosignerInfos: [{
            firstName: "Alan",
            lastName: "Parson",
            phone: "01234",
            mail: "test@example.com",
            authenticationMode: "sms"
          }],
          title: "",
          message: "",
          initMailSubject: false,
          initMail: false,
          endMailSubject: false,
          endMail: false,
          language: "FR",
          mode: "IFRAME",
          archive: false
        }
      )

      described_class.new.init_cosign({
          lstCosignedFile: [{
            name: File.expand_path("../../fixture.txt", __FILE__),
            options: [{
              visibleSignaturePage: 1,
              isVisibleSignature: "True",
              visibleRectangleSignature: "0,39,99,0",
              mail: ""
            }]
          }],
          lstCosignerInfos: [{
            firstName: "Alan",
            lastName: "Parson",
            phone: "01234",
            mail: "test@example.com",
            authenticationMode: "sms"
          }]
        }
      )
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
      expect(connect_double).to receive(:call).with(method, message: args)
    end
  end
end
