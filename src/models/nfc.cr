require "json"

module PassKit
  alias NFCTuple = NamedTuple(message: String) |
                   NamedTuple(message: String, encryption_public_key: String?)

  struct NFC
    include JSON::Serializable

    property message : String

    @[JSON::Field(key: "encryptionPublicKey")]
    property encryption_public_key : String?

    def initialize(@message, @encryption_public_key = nil)
    end

    def initialize(attributes : NFCTuple)
      @message = attributes[:message]
      @encryption_public_key = attributes[:encryption_public_key]?
    end
  end
end
