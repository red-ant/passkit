require "json"
require "./barcode"

class PassKit::Pass
  include JSON::Serializable

  APPLE_PASS_FORMAT_VERSION = 1

  #
  # Standard Fields
  #

  @[JSON::Field(key: "formatVersion")]
  property format_version : Int32

  @[JSON::Field(key: "passTypeIdentifier")]
  property pass_type_identifier : String

  @[JSON::Field(key: "organizationName")]
  property organization_name : String

  @[JSON::Field(key: "serialNumber")]
  property serial_number : String

  @[JSON::Field(key: "teamIdentifier")]
  property team_identifier : String

  property description : String

  #
  # Associated App Keys
  #

  @[JSON::Field(key: "appLaunchURL")]
  property app_launch_url : String?

  @[JSON::Field(key: "associatedStoreIdentifiers")]
  property association_store_identifiers : Array(Int32)?

  #
  # Companion App Keys
  #

  @[JSON::Field(key: "userInfo")]
  property user_info : String?

  # Expiration Keys
  @[JSON::Field(key: "expirationDate")]
  property expiration_date : Time?

  property voided : Bool?

  #
  # Relevance Keys
  #

  @[JSON::Field(key: "beacons")]
  property beacons : Array(Beacon)?

  @[JSON::Field(key: "locations")]
  property locations : Array(Location)?

  @[JSON::Field(key: "maxDistance")]
  property max_distance : Int32?

  @[JSON::Field(key: "relevantDate")]
  property relevant_date : String?

  #
  # Style Keys
  #

  @[JSON::Field(key: "boardingPass")]
  property boarding_pass : Style?

  @[JSON::Field(key: "coupon")]
  property coupon : Style?

  @[JSON::Field(key: "eventTicket")]
  property event_ticket : Style?

  @[JSON::Field(key: "generic")]
  property generic : Style?

  @[JSON::Field(key: "storeCard")]
  property store_card : Style?

  #
  # Visual Appearance Keys
  #

  property barcode : PassKit::Barcode?
  property barcodes : Array(PassKit::Barcode) = [] of PassKit::Barcode

  @[JSON::Field(key: "backgroundColor")]
  property background_color : String?

  @[JSON::Field(key: "foregroundColor")]
  property foreground_color : String?

  # TODO - add type validation
  @[JSON::Field(key: "groupingIdentifier")]
  property grouping_identifier : String?

  @[JSON::Field(key: "labelColor")]
  property label_color : String?

  @[JSON::Field(key: "logoText")]
  property logo_text : String?

  @[JSON::Field(key: "suppressStripShine")]
  property suppress_strip_shine : Bool?

  #
  # Web Service Keys
  #

  @[JSON::Field(key: "authenticationToken")]
  property authentication_token : String?

  @[JSON::Field(key: "webServiceURL")]
  property web_service_url : String?

  #
  # NFC-Enabled Pass Keys
  #

  property nfc : NFC?

  enum PassType
    Generic
    BoardingPass
    Coupon
    EventTicket
    StoreCard
  end

  def initialize(
    @pass_type_identifier,
    @organization_name,
    @serial_number,
    @team_identifier,
    @description,
    @app_launch_url = nil,
    @association_store_identifiers = [] of Int32,
    @user_info = nil,
    @expiration_date = nil,
    @voided = nil,
    @beacons = [] of Beacon,
    @max_distance = nil,
    @relevant_date = nil,
    @barcode = nil,
    @barcodes = [] of Barcode,
    @background_color = nil,
    @foreground_color = nil,
    @grouping_identifier = nil,
    @label_color = nil,
    @logo_text = nil,
    @suppress_strip_shine = nil,
    @authentication_token = nil,
    @web_service_url = nil,
    @nfc = nil,
    type : PassType = PassType::Generic,
    style : Style? = nil,
    auxiliary_fields : Array(FieldTuple | Field)? = nil,
    back_fields : Array(FieldTuple | Field)? = nil,
    header_fields : Array(FieldTuple | Field)? = nil,
    primary_fields : Array(FieldTuple | Field)? = nil,
    secondary_fields : Array(FieldTuple | Field)? = nil,
    transit_type : String? = nil,
    locations : Array(LocationTuple | Location)? = nil,
  )
    @format_version = APPLE_PASS_FORMAT_VERSION

    style = Style.new(
      auxiliary_fields: auxiliary_fields,
      back_fields: back_fields,
      header_fields: header_fields,
      primary_fields: primary_fields,
      secondary_fields: secondary_fields,
      transit_type: transit_type
    )

    if locations
      @locations = locations.map do |location|
        location.is_a?(Location) ? location : Location.new(location)
      end
    end

    case type
    when PassType::Generic
      @generic = style
    when PassType::BoardingPass
      @boarding_pass = style
    when PassType::Coupon
      @coupon = style
    when PassType::EventTicket
      @event_ticket = style
    when PassType::StoreCard
      @store_card = style
    else
      raise "unknown style: #{type}"
    end
  end

  def add_barcode(format : BarcodeFormat, message : String, message_encoding : String, alt_text : String? = nil)
    @barcodes << Barcode.new(
      format: format,
      message: message,
      message_encoding: message_encoding,
      alt_text: alt_text
    )
  end

  def add_qr_code(message : String, message_encoding : String, alt_text : String? = nil)
    add_barcode(BarcodeFormat::PKBarcodeFormatQR, message, message_encoding, alt_text)
  end

  def add_aztec_code(message : String, message_encoding : String, alt_text : String? = nil)
    add_barcode(BarcodeFormat::PKBarcodeFormatAztec, message, message_encoding, alt_text)
  end

  def add_pdf417(message : String, message_encoding : String, alt_text : String? = nil)
    add_barcode(BarcodeFormat::PKBarcodeFormatPDF417, message, message_encoding, alt_text)
  end

  def add_code_128(message : String, message_encoding : String, alt_text : String? = nil)
    add_barcode(BarcodeFormat::PKBarcodeFormatCode128, message, message_encoding, alt_text)
  end

  struct Beacon
    include JSON::Serializable

    property major : UInt16?
    property minor : UInt16?

    @[JSON::Field(key: "proximityUUID")]
    property proximity_uuid : String

    @[JSON::Field(key: "relevantText")]
    property relevant_text : String?
  end

  alias FieldValue = (String | Time | Int32 | Float64)
  alias FieldTuple = NamedTuple(key: String, value: FieldValue) |
                     NamedTuple(key: String, value: FieldValue, label: String?) |
                     NamedTuple(
                       key: String,
                       value: FieldValue,
                       label: String?,
                       attributed_value: FieldValue?,
                       change_message: String?,
                       data_detector_types: Array(String)?,
                       text_alignment: String?
                     )

  struct Field
    include JSON::Serializable

    property key : String
    property value : FieldValue
    property label : String?

    @[JSON::Field(key: "attributedValue")]
    property attributed_value : FieldValue?

    # TODO - add validation for inclusion of %@
    @[JSON::Field(key: "changeMessage")]
    property change_message : String?

    @[JSON::Field(key: "dataDetectorTypes")]
    property data_detector_types : Array(String)?

    @[JSON::Field(key: "textAlignment")]
    property text_alignment : String?

    def initialize(attributes : FieldTuple)
      @key = attributes[:key]
      @value = attributes[:value]
      @label = attributes[:label]?
      @attributed_value = attributes[:attributed_value]?
      @change_message = attributes[:change_message]?
      @data_detector_types = attributes[:data_detector_types]?
      @text_alignment = attributes[:text_alignment]?
    end
  end

  alias LocationTuple = NamedTuple(latitude: Float64, longitude: Float64) |
                        NamedTuple(latitude: Float64, longitude: Float64, altitude: Float64?) |
                        NamedTuple(latitude: Float64, longitude: Float64, altitude: Float64?, relevant_text: String?)

  struct Location
    include JSON::Serializable

    property latitude : Float64
    property longitude : Float64
    property altitude : Float64?

    @[JSON::Field(key: "relevantText")]
    property relevant_text : String?

    def initialize(
      @latitude : Float64,
      @longitude : Float64,
      @altitude : Float64? = nil,
      @relevant_text : String? = nil
    )
    end

    def initialize(attributes : LocationTuple)
      @latitude = attributes[:latitude]
      @longitude = attributes[:longitude]
      @altitude = attributes[:altitude]?
      @relevant_text = attributes[:relevant_text]?
    end
  end

  struct NFC
    include JSON::Serializable

    property message : String

    @[JSON::Field(key: "encryptionPublicKey")]
    property encryption_public_key : String?
  end

  struct Style
    include JSON::Serializable

    @[JSON::Field(key: "auxiliaryFields")]
    property auxiliary_fields : Array(Field)?

    @[JSON::Field(key: "backFields")]
    property back_fields : Array(Field)?

    @[JSON::Field(key: "headerFields")]
    property header_fields : Array(Field)?

    @[JSON::Field(key: "primaryFields")]
    property primary_fields : Array(Field)?

    @[JSON::Field(key: "secondaryFields")]
    property secondary_fields : Array(Field)?

    @[JSON::Field(key: "transitType")]
    property transit_type : String?

    def initialize(
      auxiliary_fields : Array(FieldTuple)? = nil,
      back_fields : Array(FieldTuple)? = nil,
      header_fields : Array(FieldTuple)? = nil,
      primary_fields : Array(FieldTuple)? = nil,
      secondary_fields : Array(FieldTuple)? = nil,
      @transit_type : String? = nil,
    )
      @auxiliary_fields = convert_to_fields(auxiliary_fields)
      @back_fields = convert_to_fields(back_fields)
      @header_fields = convert_to_fields(header_fields)
      @primary_fields = convert_to_fields(primary_fields)
      @secondary_fields = convert_to_fields(secondary_fields)
    end

    def convert_to_fields(fields : Array(FieldTuple)?)
      fields.map { |field| Field.new(field) } if fields
    end
  end
end
