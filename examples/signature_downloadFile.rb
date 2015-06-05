require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
res = c.signature_list('','',count=1).body[:get_list_cosign_response][:return]
id_demand = res[:cosignature_event]
puts 'Getting signed files with id Demand '+id_demand+ ' ...'
#Other options

res = c.get_signed_files(id_demand).body[:get_cosigned_files_from_demand_response][:return]
file = []
file_name =[]


# Get files contents
for el in res
  file << el[:file]
end

# Get files names
for el in res
   file_name << (el[:file_name])
end

# Write contents associated to each file
for el in file_name
     rdm = (0...5).map { ('a'..'z').to_a[rand(26)] }.join
     old_path= file_name[file_name.index(el)]
     new_path = rdm+'_'+File.basename(old_path)
     signedFile = open('documents/'+new_path, 'w')
     signedFile.write(Base64.decode64(file[file_name.index(el)]))
     puts 'Signed file : ' +File.absolute_path(new_path)
end

rescue Savon::SOAPFault => error
  puts error
end
