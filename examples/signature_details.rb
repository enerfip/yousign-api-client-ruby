require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
res = c.signature_list('','',count=1).body[:get_list_cosign_response][:return]
id_demand = res[:cosignature_event]

puts 'Getting information from signature with id Demand '+id_demand+ ' ...'

#Other options
for el in c.signature_details(id_demand).body[:get_infos_from_cosignature_demand_response][:return]
  puts el
end
rescue Savon::SOAPFault => error
  puts error
end
