module YousignApi
  module Payload
    class CancelCosignatureDemand < Base
      attribute :idDemand
      attribute :token, default: ""
      attribute :idFile, default: ""
    end
  end
end

