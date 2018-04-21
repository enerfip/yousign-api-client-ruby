require "base64"

module YousignApi
  module Payload
    class Document < Base
      attribute  :name
      collection :options, type: "DocumentOptions"

      def to_payload
        f= File.path(name)
        afile = File.open(f, 'r')
        test_file = afile.read
        content = Base64.encode64(test_file)
        afile.close
        {
          name: File.basename(name),
          content: content,
          visibleOptions: options.map(&:to_payload)
        }
      end
    end
  end
end

