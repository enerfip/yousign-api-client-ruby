module YousignApi
  module Payload
    class AlertCosigners < Base
      attribute :idDemand
      attribute :mailSubject, default: ""
      attribute :mail,        default: ""
      attribute :language,    default: ""
    end
  end
end

