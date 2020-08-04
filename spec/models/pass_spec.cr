require "../spec_helper"

describe PassKit::Pass do
  it "can successfully serialize a valid JSON file" do
    json = File.read(fixture_file("generic_pass_valid.json"))
    pass = PassKit::Pass.from_json(json)
    pass.format_version.should eq(1)
    pass.pass_type_identifier.should eq("pass.technology.place.dev")

    locations = pass.locations.as(Array(PassKit::Pass::Location))
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
      logo_text: "Willy Wonka inc."
    )
    pass.pass_type_identifier.should eq "pass.com.example"
  end

  it "can be passed a barcode" do
    pass = PassKit::Pass.new(
      pass_type_identifier: "pass.com.example",
      organization_name: "PlaceOS",
      serial_number: "12345",
      team_identifier: "TM123",
      description: "The golden ticket",
      logo_text: "Willy Wonka inc."
    )

    pass.add_qr_code("1234", "iso-8859-1")

    pass.barcodes[0].message.should eq "1234"
    pass.barcodes[0].message_encoding.should eq "iso-8859-1"
  end
end

private def fixture_file(file : String)
  "spec/fixtures/#{file}"
end
