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

  alias BarcodeTuple = NamedTuple(format: BarcodeFormat, message: String, message_encoding: String) |
                       NamedTuple(format: BarcodeFormat, message: String, message_encoding: String, alt_text: String?)

  struct Barcode
    include JSON::Serializable

    # shortcut constants
    QR = BarcodeFormat::PKBarcodeFormatQR
    PDF417 = BarcodeFormat::PKBarcodeFormatPDF417
    AZTEC = BarcodeFormat::PKBarcodeFormatAztec
    CODE128 = BarcodeFormat::PKBarcodeFormatCode128

    property format : BarcodeFormat
    property message : String

    @[JSON::Field(key: "messageEncoding")]
    property message_encoding : String

    @[JSON::Field(key: "altText")]
    property alt_text : String?

    def initialize(@format, @message, @message_encoding, @alt_text = nil)
    end

    def initialize(attributes : BarcodeTuple)
      @format = attributes[:format]
      @message = attributes[:message]
      @message_encoding = attributes[:message_encoding]
      @alt_text = attributes[:alt_text]?
    end
  end
end
