require "json"

module PassKit
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

    private def convert_to_fields(fields : Array(FieldTuple)?)
      fields.map { |field| Field.new(field) } if fields
    end
  end

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
end
