module YousignApi
  module Payload
    class GetInfosFromCosignatureDemand < Base
      attribute :idDemand
      attribute :token, default: ""
    end
  end
end
