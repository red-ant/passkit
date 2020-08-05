require "../spec_helper"

describe PassKit::Pass do
  it "can successfully serialize a valid JSON file" do
    json = File.read(fixture_file("generic_pass_valid.json"))
    pass = PassKit::Pass.from_json(json)
    pass.format_version.should eq(1)
    pass.pass_type_identifier.should eq("pass.technology.place.dev")

    locations = pass.locations.as(Array(PassKit::Location))
    locations.first.latitude.should eq 37.6189722
    locations.first.longitude.should eq -122.3748889

    barcode = pass.barcode.as(PassKit::Barcode)
    barcode.message.should eq "123456789"
    barcode.format.should eq PassKit::BarcodeFormat::PKBarcodeFormatPDF417
    barcode.message_encoding.should eq "iso-8859-1"
  end

  it "can be instantiated" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      logo_text: "Willy Wonka inc.",
      type: PassKit::PassType::Generic,
      header_fields: [{key: "test", value: "test"}]
    )
    pass.pass_type_identifier.should eq "pass.com.example"
  end

  it "can be passed a qr code" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      logo_text: "Willy Wonka inc.",
      barcodes: [{
        format: PassKit::Barcode::QR,
        message: "well, hello there",
        message_encoding: "iso-8859-1"
      }]
    )

    barcodes = pass.barcodes.as(Array(PassKit::Barcode))
    barcodes[0].format.should eq PassKit::BarcodeFormat::PKBarcodeFormatQR
    barcodes[0].message.should eq "well, hello there"
  end

  it "can be passed an array of locations" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      locations: [
        {
          latitude: 37.424299996,
          longitude: -122.0925956000001
        },
        {
          latitude: 37.424299996,
          longitude: -122.0925956000001,
          altitude: 200.0,
          relevant_text: "This is some relevant text"
        },
        PassKit::Location.new(latitude: 31.1, longitude: -121.1)
      ]
    )

    locations = pass.locations.as(Array(PassKit::Location))
    locations[0].latitude.should eq 37.424299996
    locations[0].longitude.should eq -122.0925956000001
    locations[1].latitude.should eq 37.424299996
    locations[1].longitude.should eq -122.0925956000001
    locations[1].altitude.should eq 200.0
    locations[1].relevant_text.should eq "This is some relevant text"
    locations[2].latitude.should eq 31.1
    locations[2].longitude.should eq -121.1
  end

  it "can be passed an array of beacons" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      beacons: [
        { proximity_uuid: "1234ABCD" },
        { proximity_uuid: "4321DCBA", major: UInt16.new(1), minor: UInt16.new(2) },
        PassKit::Beacon.new(proximity_uuid: "1111AAAA")
      ]
    )

    beacons = pass.beacons.as(Array(PassKit::Beacon))
    beacons[0].proximity_uuid.should eq "1234ABCD"
    beacons[1].proximity_uuid.should eq "4321DCBA"
    beacons[1].major.should eq 1
    beacons[1].minor.should eq 2
    beacons[2].proximity_uuid.should eq "1111AAAA"
  end

  it "can be passed an NFC tuple" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      nfc: { message: "hello" }
    )

    pass.nfc.not_nil!.message.should eq "hello"
  end
end

private def fixture_file(file : String)
  "spec/fixtures/#{file}"
end
