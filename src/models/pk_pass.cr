require "compress/zip"
require "file"
require "http/client"
require "./manifest"
require "./pass"
require "./signer"

class PassKit::PKPass
  getter manifest : Manifest

  def initialize(pass : Pass)
    @pass = pass
    @manifest = Manifest.new(@pass)
    @signer = Signer.new
  end

  def add_url(url : String)
    @manifest.add_url(url)
  end

  def add_file(name : String, content : String)
    @manifest.add_file(name, content)
  end

  def to_s
    to_io.to_s
  end

  def to_io
    io = IO::Memory.new
    generate(io)
    io
  end

  private def generate(io : IO)
    manifest_json = @manifest.to_json
    signature = @signer.sign(manifest_json)

    Compress::Zip::Writer.open(io) do |zip|
      zip.add "pass.json", @pass.to_json
      zip.add "manifest.json", manifest_json
      zip.add "signature", signature

      @manifest.resources.each do |resource|
        zip.add resource.name, resource.content
      end
    end
  end
end
