require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
for el in c.signature_list('','',count=10).body[:get_list_cosign_response][:return]
  puts '*******************************************************************************************************************************'
  for sign in el
    puts '**** Files Info ********'
    puts el[:file_infos]
    puts '**** Creation Date *****'
    puts el[:date_creation]
    puts '**** Status ************'
    puts el[:status]
    puts '**** Signers Info ******'
    puts el[:cosigner_infos]
    puts '**** Initiator *********'
    puts el[:initiator]
    puts '**** Signature event ***'
    puts el[:cosignature_event]
  end
end
rescue Savon::SOAPFault => error
  puts error
end
