require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
iua = ''

res =c.get_archive(iua).body[:get_archive_response][:return]

content = res[:file]
rdm = (0...5).map { ('a'..'z').to_a[rand(26)] }.join
old_path = res[:file_name]
new_path = rdm+'_'+File.basename(old_path)
signedFile = open('documents/'+new_path, 'w')
signedFile.write(Base64.decode64(content))
puts 'Archive saved in : ' +File.absolute_path(new_path)

rescue Savon::SOAPFault => error
  puts error
end
