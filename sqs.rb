require 'cgi'
require 'digest'
require 'net/http'
require 'openssl'
require 'base64'
require 'time'

class Sqs
  def initialize access_key_id, secret_access_key, endpoint
    @access_key_id = access_key_id
    @secret_access_key = secret_access_key
    @endpoint = URI.parse(endpoint)
  end
  def send_message message
    params = {
      'AWSAccessKeyId' => @access_key_id,
      'Action' => 'SendMessage',
      'MessageBody' => message,
      'Timestamp' => Time.now.gmtime.iso8601,
      'SignatureMethod' => 'HmacSHA1',
      'SignatureVersion' => '2',
      'Version' => '2009-02-01'
    }.sort_by { |key,value| key }
    url = construct_url params
    Net::HTTP.get(URI.parse(url))
  end

  private
  def construct_url params
    joined_params = params.collect{ |key, value| "#{CGI.escape(key)}=#{CGI.escape(value)}"}.join("&")
    key = keygen(@secret_access_key, joined_params)
    "#{@endpoint}?#{joined_params}&Signature=#{key}"
  end 

  def keygen key, params_string
    string_to_sign = "GET\n#{@endpoint.host}\n#{@endpoint.path}\n" + params_string
    digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, key, string_to_sign)
    Base64.encode64(hmac).chomp
  end
end