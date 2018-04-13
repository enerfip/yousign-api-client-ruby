module YousignApi
  module Payload
    class DocumentOptions < Base
      attribute :visibleSignaturePage,      default: 1
      attribute :isVisibleSignature,        default: "True"
      attribute :visibleRectangleSignature, default: "0,39,99,0"
      attribute :mail,                      default: ""
    end
  end
end

