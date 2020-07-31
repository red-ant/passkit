require "json"

module PassKit
  enum BarcodeFormat
    PKBarcodeFormatQR
    PKBarcodeFormatPDF417
    PKBarcodeFormatAztec
    PKBarcodeFormatCode128

    def to_json(json : JSON::Builder)
      json.string(to_s)
    end
  end

  class Barcode
    include JSON::Serializable

    def initialize(@format, @message, @message_encoding, @alt_text = nil)
    end

    property format : BarcodeFormat
    property message : String

    @[JSON::Field(key: "messageEncoding")]
    property message_encoding : String

    @[JSON::Field(key: "altText")]
    property alt_text : String?
  end
end
