require "../spec_helper"
require "webmock"
require "openssl"

describe PassKit::Manifest do
  describe "#to_json" do
    it "works when empty" do
      manifest = create_manifest
      manifest.to_json.should eq "{\"pass.json\":\"623a67d8ff6103a668eb7e75935151f10bad4afb\"}"
    end

    it "works with an added URL" do
      url = "http://example.com/my/icon.txt"
      WebMock.stub(:get, url).to_return(status: 200, body: "OK")

      manifest = create_manifest
      manifest.add_url(url)
      manifest.to_json.should eq "{\"pass.json\":\"623a67d8ff6103a668eb7e75935151f10bad4afb\",\"icon.txt\":\"9ce3bd4224c8c1780db56b4125ecf3f24bf748b7\"}"
    end

    it "handles URLs that result in a 404" do
      url_ok = "http://example.com/my/icon.txt"
      url_not_found = "http://example.com/my/stripe.txt"
      WebMock.stub(:get, url_ok).to_return(status: 200, body: "OK")
      WebMock.stub(:get, url_not_found).to_return(status: 404, body: "Not found")

      manifest = create_manifest
      manifest.add_url(url_ok)
      manifest.add_url(url_not_found)

      expect_raises(Error::HTTPError) do
        manifest.to_json
      end
    end
  end

  describe "#valid?" do
    it "is valid when icon.png is added" do
      manifest = create_manifest
      manifest.add_file("icon.png", "test")
      manifest.valid?.should be_true
    end

    it "is valid when icon@2x.png is added" do
      manifest = create_manifest
      manifest.add_file("icon@2x.png", "test")
      manifest.valid?.should be_true
    end

    it "is not valid when no icons are added" do
      manifest = create_manifest
      manifest.valid?.should be_false
    end
  end

  describe "#validate!" do
    it "is fine when the manifest is valid" do
      manifest = create_manifest
      manifest.add_file("icon.png", "test")
      manifest.validate!.should be_nil
    end

    it "raises an error if the manifest is invalid" do
      manifest = create_manifest

      expect_raises(Error::InvalidManifest) do
        manifest.validate!
      end
    end
  end
end
