require "json"
require "digest"
require "http/client"
require "http/client/response"
require "uri"
require "../error"

class PassKit::Manifest
  getter resources : Array(Resource)

  def initialize(pass : Pass)
    @pass = pass
    @resources = [] of Resource
  end

  def add_url(url : String)
    @resources << URLResource.new(url)
  end

  def add_file(name : String, content : String)
    @resources << FileResource.new(name: name, content: content)
  end

  def to_json
    JSON.build do |json|
      json.object do
        json.field "pass.json", Digest::SHA1.hexdigest(@pass.to_json)

        @resources.each do |resource|
          json.field resource.name, resource.digest
        end
      end
    end
  end

  def validate!
    raise Error::InvalidManifest.new "manifest missing required icon.png" unless valid?
  end

  def valid?
    has_icon?
  end

  def has_icon?
    @resources.any? { |resource| resource.name == "icon.png" || resource.name == "icon@2x.png" }
  end

  abstract class Resource
    def digest
      Digest::SHA1.hexdigest(content)
    end
  end

  class FileResource < Resource
    property name : String
    property content : String

    def initialize(@name, @content)
    end
  end

  class URLResource < Resource
    @response : HTTP::Client::Response?

    def initialize(url : String)
      @uri = URI.parse(url)
    end

    def name
      File.basename(@uri.path)
    end

    def response
      @response ||= get
    end

    def content
      response.body
    end

    private def get : HTTP::Client::Response
      response = HTTP::Client.get(@uri)

      unless response.success?
        raise Error::HTTPError.new(response.status, response.body, response.status.description)
      end

      response
    end
  end

end
