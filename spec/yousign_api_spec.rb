require 'spec_helper'

describe YousignApi do
  subject { YousignApi }
  before { reinitialize_config }
  after  { reinitialize_config }

  it "has a version number" do
    expect(YousignApi::VERSION).not_to be nil
  end

  it "is not configured by default" do
    expect(subject).not_to be_configured
  end

  it "is configurable with the setup method, then it's configured" do
    subject.setup do |config|
      config.username = "some_user"
      config.password = "some_password"
      config.apikey = "some_apikey"
      config.environment = "prod"
      config.encrypt_password = true
    end

    expect(subject).to be_configured
    expect(subject.username).to eq "some_user"
    expect(subject.password).to eq "some_password"
    expect(subject.apikey).to eq "some_apikey"
    expect(subject.environment).to eq "prod"
    expect(subject.encrypt_password).to eq true
  end

  it "has default values set" do
    expect(subject.username).to be_nil
    expect(subject.environment).to eq "demo"
    expect(subject.encrypt_password).to eq false
  end
end
