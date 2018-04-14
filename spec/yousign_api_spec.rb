require 'spec_helper'

describe YousignApi do
  it "has a version number" do
    expect(YousignApi::VERSION).not_to be nil
  end

  it "is configurable with the setup method, then it's configured" do
    YousignApi.setup do |config|
      config.username = "some_user"
      config.password = "some_password"
      config.apikey = "some_apikey"
    end

    expect(subject).to be_configured
    expect(subject.username).to eq "some_user"
    expect(subject.password).to eq "some_password"
    expect(subject.apikey).to eq "some_apikey"
  end
end
