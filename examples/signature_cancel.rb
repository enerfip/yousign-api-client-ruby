require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
res = c.signature_list('','',count=1).body[:get_list_cosign_response][:return]
id_demand = res[:cosignature_event]

puts c.signature_cancel(id_demand).body[:cancel_cosignature_demand_response][:return] ? 'Signature cancelled' :'Signature not cancelled'
rescue Savon::SOAPFault => error
  puts error
end
