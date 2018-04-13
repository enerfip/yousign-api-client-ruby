require "yousign_api/version"
require "yousign_api/client"
require "yousign_api/objects"
require "yousign_api/setup"

module YousignApi
  include Setup

  setup_defaults username: nil,
                 password: nil,
                 apikey: nil,
                 environment: "demo",
                 encrypt_password: false
end
