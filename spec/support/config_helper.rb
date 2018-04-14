module YousignApi
  module ConfigHelper
    def reinitialize_config
      YousignApi.reinitialize_config
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
