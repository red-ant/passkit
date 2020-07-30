class Error < Exception
  getter message

  def initialize(@message : String = "")
    super(message)
  end

  class MissingConfiguration < Error
  end

  class MissingFile < Error
  end
end
