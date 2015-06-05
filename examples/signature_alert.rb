require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
res = c.signature_list('','',count=1).body[:get_list_cosign_response][:return]
id_demand = res[:cosignature_event]

#Other options
mail_subject =''
mail=''
language=''

puts c.signature_alert(id_demand, mail_subject, mail, language).body[:alert_cosigners_response][:return] ? 'Alert sent' :'Alert not send'
rescue Savon::SOAPFault => error
  puts error
end
