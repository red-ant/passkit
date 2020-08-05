require "json"

module PassKit
  alias BeaconTuple = NamedTuple(proximity_uuid: String) |
                      NamedTuple(proximity_uuid: String, major: UInt16?, minor: UInt16?) |
                      NamedTuple(proximity_uuid: String, major: UInt16?, minor: UInt16?, relevant_text: String?)

  struct Beacon
    include JSON::Serializable

    @[JSON::Field(key: "proximityUUID")]
    property proximity_uuid : String

    property major : UInt16?
    property minor : UInt16?

    @[JSON::Field(key: "relevantText")]
    property relevant_text : String?

    def initialize(@proximity_uuid, @major = nil, @minor = nil, @relevant_text = nil)
    end

    def initialize(attributes : BeaconTuple)
      @proximity_uuid = attributes[:proximity_uuid]
      @major = attributes[:major]?
      @minor = attributes[:minor]?
      @relevant_text = attributes[:relevant_text]?
    end
  end
end
