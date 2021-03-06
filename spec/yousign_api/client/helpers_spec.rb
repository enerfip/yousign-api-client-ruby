require "spec_helper"

RSpec.describe YousignApi::Client do
  describe "#new" do
    it "raises an error when instanciating a client if gem is not configured" do
      reinitialize_config
      expect { described_class.new }.to raise_error "Yousign was not configured, please use `Yousign.setup` before using Yousign API client"
    end
    it "returns a new client otherwise" do
      configure_dummy_values
      expect(described_class.new).to be_kind_of described_class
      reinitialize_config
    end
  end

  describe "#base_url and iframe_url" do
    it "depends on environment" do
      YousignApi.setup { |config| config.environment = "demo" }
      expect(described_class.new.base_url).to eq "https://apidemo.yousign.fr:8181/"
      expect(described_class.new.iframe_url("some_token")).to eq "https://demo.yousign.fr/public/ext/cosignature/some_token"

      YousignApi.setup { |config| config.environment = "prod" }
      expect(described_class.new.base_url).to eq "https://api.yousign.fr:8181/"
      expect(described_class.new.iframe_url("some_token")).to eq "https://yousign.fr/public/ext/cosignature/some_token"

      YousignApi.setup { |config| config.environment = "invalid_environment" }
      expect { described_class.new.base_url }.to raise_error "The Yousign environment was set to invalid_environment, but it should be either 'demo' or 'prod'"
      expect { described_class.new.iframe_url("some_token") }.to raise_error "The Yousign environment was set to invalid_environment, but it should be either 'demo' or 'prod'"
      # teardown
      YousignApi.setup { |config| config.environment = "demo" }
    end
  end

  describe "#headers" do
    it "depends on config" do
      YousignApi.setup do |config|
        config.username = "acme"
        config.password = "some_password"
        config.apikey = "the_key"
      end
      expect(described_class.new.headers).to eq username: "acme", password: "some_password", apikey: "the_key"
    end
  end
end
