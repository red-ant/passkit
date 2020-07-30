require "file"
require "openssl"
require "../constants"
require "../error"

class PassKit::Signer
  @signing_cert : String
  @private_key : String
  @private_key_password : String | Nil
  @wwdr_cert : String

  def initialize
    @signing_cert = check_config_file(PassKit::SIGNING_CERT, "SIGNING_CERT")
    @private_key = check_config_file(PassKit::PRIVATE_KEY, "PRIVATE_KEY")
    @private_key_password = PassKit::PRIVATE_KEY_PASSWORD
    @wwdr_cert = check_config_file(PassKit::WWDR_CERT, "WWDR_CERT")
  end

  def sign(data) : String
    data_file = File.tempfile { |file| file.print(data) }
    signed_data = `openssl smime -binary -sign -certfile #{@wwdr_cert} -signer #{@signing_cert} -inkey #{@private_key} -in #{data_file.path} -outform DER -passin pass:#{@private_key_password}`
    data_file.delete
    signed_data
  end

  private def check_config_file(path : String | Nil, name : String) : String
    raise Error::MissingConfiguration.new "missing ENV configuration for #{name}" if path.nil?
    raise Error::MissingFile.new "file does not exist #{path} for #{name}" unless File.exists?(path)
    path
  end
end
