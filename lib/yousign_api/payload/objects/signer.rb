module YousignApi
  module Payload
    class Signer < Base
      attribute :firstName
      attribute :lastName
      attribute :phone
      attribute :mail
      attribute :authenticationMode, default: "sms"
    end
  end
end

