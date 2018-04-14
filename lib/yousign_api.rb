require "yousign_api/version"
require "yousign_api/setup"
require "yousign_api/payload"
Dir[File.expand_path("payload/**/*.rb", __FILE__)].each { |f| require f }
require "yousign_api/client"

module YousignApi
  include Setup

  setup_defaults username: nil,
                 password: nil,
                 apikey: nil,
                 environment: "demo",
                 encrypt_password: false
end
