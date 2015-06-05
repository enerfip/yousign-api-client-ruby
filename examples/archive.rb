require 'Ys_api/client'

begin
# c = YsApi::Client.new(:username => '',
#                       :password => '',
#                       :apikey => '',
#                       :environment => 'demo')

c = YsApi::Client.new(:conf =>'../config/config.ini')
file_name= 'documents/doc1.pdf'
afile = File.open(file_name, 'r')
test_file = afile.read
content = Base64.encode64(test_file)

# subject = "a"
# date1 = "01-01-15"
# date2 = "12-12-15"
# type = "contract"
author = "Martin Voisin"
comment = "My Comment"
# ref = "ref"
# amount = "amount"
# tag =  ['a']
# generic1 = ['b']
# generic2 = ['c']

file = {:content => content, :file_name =>file_name, :author => author, :comment => comment}

for el in c.archive(file).body[:archive_response][:return]
  puts el
end

rescue Savon::SOAPFault => error
  puts error
end

