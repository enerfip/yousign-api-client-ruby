module YousignApi
  module Payload
    class GetCosignedFilesFromDemand < Base
      attribute :idDemand
      attribute :token,  default: ""
      attribute :idFile, default: ""
    end
  end
end
