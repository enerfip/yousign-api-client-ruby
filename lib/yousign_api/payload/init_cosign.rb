module YousignApi
  module Payload
    class InitCosign < Base
      collection :lstCosignedFile,  type: "Document"
      collection :lstCosignerInfos, type: "Signer"
      attribute :title,           default: ""
      attribute :message,         default: ""
      attribute :initMailSubject, default: false
      attribute :initMail,        default: false
      attribute :endMailSubject,  default: false
      attribute :endMail,         default: false
      attribute :language,        default: "FR"
      attribute :mode,            default: "IFRAME"
      attribute :archive,         default: false
    end
  end
end
