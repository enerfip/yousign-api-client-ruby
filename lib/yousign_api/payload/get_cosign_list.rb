module YousignApi
  module Payload
    class SignatureList < Base
      attribute :search,      default: ""
      attribute :firstResult, default: ""
      attribute :count,       default: 1000
      attribute :status,      default: ""
      attribute :dateBegin,   default: ""
      attribute :dateEnd,     default: ""
    end
  end
end
