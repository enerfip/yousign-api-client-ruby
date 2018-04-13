$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yousign_api'
Dir[File.expand_path("../support/**/*.rb", __FILE__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = :random
end

