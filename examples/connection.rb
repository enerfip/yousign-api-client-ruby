require 'Ys_api/client'

# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')

begin
  puts c.connection ?  'Successful Authentication' :  'Authentication failed'
rescue Savon::SOAPFault => error
  puts error
end
