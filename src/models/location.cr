require "json"

module PassKit
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

    def initialize(@latitude, @longitude, @altitude = nil, @relevant_text = nil)
    end

    def initialize(attributes : LocationTuple)
      @latitude = attributes[:latitude]
      @longitude = attributes[:longitude]
      @altitude = attributes[:altitude]?
      @relevant_text = attributes[:relevant_text]?
    end
  end
end
