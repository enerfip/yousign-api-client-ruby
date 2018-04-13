module YousignApi
  module ConfigHelper
    def reinitialize_config
      Object.class_eval do
        remove_const "YousignApi"
        load File.expand_path("../../../lib/yousign_api/setup.rb", __FILE__)
        load File.expand_path("../../../lib/yousign_api.rb", __FILE__)
        load File.expand_path("../../../lib/yousign_api/version.rb", __FILE__)
      end
    end

    def configure_dummy_values
      YousignApi.setup do |config|
        config.username = "me"
        config.password = "password"
        config.apikey   = "apikey"
      end
    end
  end
end

RSpec.configure do |config|
  config.include YousignApi::ConfigHelper
end
