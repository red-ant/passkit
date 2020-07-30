require "json"

class PassKit::Pass
  include JSON::Serializable

  APPLE_PASS_FORMAT_VERSION = 1

  #
  # Standard Fields
  #

  @[JSON::Field(key: "formatVersion")]
  property format_version : Int32

  @[JSON::Field(key: "passTypeIdentifier")]
  property pass_type_idenitifer : String

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
  property relevant_date : Time?

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

  property barcode : Barcode?
  property barcodes : Array(Barcode)?

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
    @pass_type_idenitifer,
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
    @locations = [] of Location,
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
    style : Style? = nil
  )
    @format_version = APPLE_PASS_FORMAT_VERSION

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
      @store_ticket = style
    end
  end

  struct Barcode
    include JSON::Serializable

    # TODO - format validation?
    property format : String
    property message : String

    @[JSON::Field(key: "messageEncoding")]
    property message_encoding : String

    @[JSON::Field(key: "altText")]
    property alt_text : String?
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

  struct Field
    include JSON::Serializable

    alias FieldValue = (String | Time | Int32 | Float64)?

    property key : String
    property label : String?
    property value : FieldValue

    @[JSON::Field(key: "attributedValue")]
    property attributed_value : FieldValue?

    # TODO - add validation for inclusion of %@
    @[JSON::Field(key: "changeMessage")]
    property change_message : String?

    @[JSON::Field(key: "dataDetectorTypes")]
    property data_detector_types : Array(String)?

    @[JSON::Field(key: "textAlignment")]
    property text_alignment : String?
  end

  struct Location
    include JSON::Serializable

    property latitude : Float64
    property longitude : Float64
    property altitude : Float64?

    @[JSON::Field(key: "relevantText")]
    property relevant_text : String?
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
  end
end