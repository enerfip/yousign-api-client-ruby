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

  describe "#endpoint" do
    it "depends on environment" do
      YousignApi.setup { |config| config.environment = "demo" }
      expect(described_class.new.endpoint).to eq "https://apidemo.yousign.fr:8181/"

      YousignApi.setup { |config| config.environment = "prod" }
      expect(described_class.new.endpoint).to eq "https://api.yousign.fr:8181/"

      YousignApi.setup { |config| config.environment = "invalid_environment" }
      expect { described_class.new.endpoint }.to raise_error "The Yousign environment was set to invalid_environment, but it should be either 'demo' or 'prod'"
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

      YousignApi.setup do |config|
        config.encrypt_password = true
      end
      expect(described_class.new.headers).to eq username: "acme", password: "8a0e3cf25e98c5a3eb03eb36d4b88ced9176cd2f", apikey: "the_key"
    end
  end
end
