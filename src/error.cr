require "http"

class Error < Exception
  getter message

  def initialize(@message : String = "")
    super(message)
  end

  class MissingConfiguration < Error
  end

  class MissingFile < Error
  end

  class InvalidManifest < Error
  end

  class HTTPError < Error
    property http_status : HTTP::Status
    property http_body : String

    def initialize(@http_status, @http_body, @message = nil)
    end
  end
end
