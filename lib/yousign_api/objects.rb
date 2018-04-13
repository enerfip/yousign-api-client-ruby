require 'yousign_api/version'
require 'base64'

module YousignApi

  def self.files(name, visibleOptions)
    f= File.path(name)
    afile = File.open(f, 'r')
    test_file = afile.read
    content = Base64.encode64(test_file)
    afile.close
    {:name => name,
     :content => content,
     :visibleOptions => visibleOptions}
  end

  def self.options (visibleSignaturePage=1, isVisibleSignature='True', visibleRectangleSignature='0,39,99,0', mail='')
    {:visibleSignaturePage =>visibleSignaturePage,
     :isVisibleSignature =>isVisibleSignature,
     :visibleRectangleSignature => visibleRectangleSignature,
     :mail => mail}
  end

  def self.signers(firstName, lastName, phone, mail, authenticationMode='sms')
    {:firstName => firstName,
     :lastName => lastName,
     :phone => phone,
     :mail => mail,
     :authenticationMode => authenticationMode}
  end
end

