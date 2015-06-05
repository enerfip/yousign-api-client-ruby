require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
iua = ''

res = c.get_complete_archive(iua).body[:get_complete_archive_response][:return]

zip_content = res[:file]

zip_path= 'documents/'+File.basename(res[:file_name])
arch_file = open(zip_path, 'w')
arch_file.write(Base64.decode64(zip_content))
puts 'Archive saved in : ' +File.absolute_path(zip_path)

rescue Savon::SOAPFault => error
  puts error
end

