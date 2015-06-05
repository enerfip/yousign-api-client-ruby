require 'Ys_api/client'
require 'Ys_api/version'
require 'Ys_api/objects'

# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
#Signers information (one or more)
lst_signers_info = [YsApi::signers('Marc','Chambert','+33601020304','marc@hostname.fr','sms'),
                    YsApi::signers('John','Doe','+33601020305','john@hostname.fr','sms')]

# Files to sign with their information
# In this example, you choose your options for the first file, then for the second one (for each signer).
op = [[YsApi::options(1, 'True','0,39,99,0','marc@hostname.fr'),
       YsApi::options(1, 'True','0,39,80,0','john@hostname.fr')],

      [YsApi::options(1, 'True','0,39,70,0','marc@hostname.fr'),
       YsApi::options(1, 'True','0,39,60,0','john@hostname.fr')]]

lst_files = ['documents/doc1.pdf', 'documents/doc2.pdf']
lst_signed_file = []


for i in 0..lst_files.length-1
    lst_signed_file << YsApi::files(lst_files[i],op[i])
end


#Other options
message='',
title='',
init_mail_subject=false
init_mail=false
end_mail_subject=false
end_mail=false
language='FR'
mode='IFRAME'
archive=false

begin
  res = c.signature_init(lst_signed_file, lst_signers_info, title, message, init_mail_subject, init_mail, end_mail_subject, end_mail, language, mode, archive).body[:init_cosign_response][:return]
  rescue Savon::SOAPFault => error
      puts error
    end

tokens = res[:tokens]
for token in tokens
     url = c.urliframe+'public/ext/cosignature/'+token[:token]
     puts 'Link for '+token[:mail]+' : '+url
   end

puts ' ********************** Signed files *******************************'

signed=[]
for el in res[:file_infos]
     signed << File.basename(el[:file_name])
   end
puts signed

puts ' ********************** idDemand : ' +res[:id_demand]+ '*************'
puts ' ********************** Files Info *********************************'
puts res[:file_infos]
puts ' ********************** Tokens *************************************'
puts res[:tokens]
