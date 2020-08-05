require "json"
require "./barcode"
require "./beacon"
require "./location"
require "./nfc"
require "./style"

module PassKit
  enum PassType
    Generic
    BoardingPass
    Coupon
    EventTicket
    StoreCard
  end

  class Pass
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
      @max_distance = nil,
      @relevant_date = nil,
      @barcode = nil,
      @background_color = nil,
      @foreground_color = nil,
      @grouping_identifier = nil,
      @label_color = nil,
      @logo_text = nil,
      @suppress_strip_shine = nil,
      @authentication_token = nil,
      @web_service_url = nil,

      # Style related
      type : PassType = PassType::Generic,
      style : Style? = nil,
      auxiliary_fields : Array(FieldTuple | Field)? = nil,
      back_fields : Array(FieldTuple | Field)? = nil,
      header_fields : Array(FieldTuple | Field)? = nil,
      primary_fields : Array(FieldTuple | Field)? = nil,
      secondary_fields : Array(FieldTuple | Field)? = nil,
      transit_type : String? = nil,

      locations : Array(LocationTuple | Location)? = nil,
      barcodes : Array(BarcodeTuple | Barcode)? = nil,
      beacons : Array(BeaconTuple | Beacon)? = nil,
      nfc : (NFC | NFCTuple)? = nil
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

      if locations
        @locations = locations.map do |location|
          location.is_a?(Location) ? location : Location.new(location)
        end
      end

      if barcodes
        @barcodes = barcodes.map do |barcode|
          barcode.is_a?(Barcode) ? barcode : Barcode.new(barcode)
        end
      end

      if beacons
        @beacons = beacons.map do |beacon|
          beacon.is_a?(Beacon) ? beacon : Beacon.new(beacon)
        end
      end

      if nfc
        @nfc = nfc.is_a?(NFC) ? nfc : NFC.new(nfc)
      end
    end
  end
end
