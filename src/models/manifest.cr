require "json"
require "digest"
require "http/client"
require "http/client/response"
require "uri"

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
    @resources << FileResource.new(name, content)
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

  abstract class Resource
    def digest
      Digest::SHA1.hexdigest(content)
    end
  end

  class FileResource < Resource
    getter name
    getter content

    def initialize(@name : String, @content : String)
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
        raise HTTPError.new(response.status, response.body, response.status.description)
      end

      response
    end
  end

  class HTTPError < ::Exception
    property http_status : HTTP::Status
    property http_body : String

    def initialize(@http_status, @http_body, @message = nil)
    end
  end
end
