require "awesome_resource/client/response"
require "rest-client"
require "json"
require "active_support/core_ext/string"

module AwesomeResource
  class HttpException < StandardError;
  end

  UNHANDLED_RESPONSES = {
    100 => 'Continue',
    101 => 'Switching Protocols',
    102 => 'Processing', #WebDAV

    202 => 'Accepted',
    203 => 'Non-Authoritative Information', # http/1.1
    205 => 'Reset Content',
    206 => 'Partial Content',
    207 => 'Multi-Status', #WebDAV

    300 => 'Multiple Choices',
    301 => 'Moved Permanently',
    302 => 'Found',
    303 => 'See Other', # http/1.1
    304 => 'Not Modified',
    305 => 'Use Proxy', # http/1.1
    306 => 'Switch Proxy', # no longer used
    307 => 'Temporary Redirect', # http/1.1

    400 => 'Bad Request',
    401 => 'Unauthorized',
    402 => 'Payment Required',
    403 => 'Forbidden',
    404 => 'Resource Not Found',
    405 => 'Method Not Allowed',
    406 => 'Not Acceptable',
    407 => 'Proxy Authentication Required',
    408 => 'Request Timeout',
    409 => 'Conflict',
    410 => 'Gone',
    411 => 'Length Required',
    412 => 'Precondition Failed',
    413 => 'Request Entity Too Large',
    414 => 'Request-URI Too Long',
    415 => 'Unsupported Media Type',
    416 => 'Requested Range Not Satisfiable',
    417 => 'Expectation Failed',
    418 => 'I\'m A Teapot',
    421 => 'Too Many Connections From This IP',
    423 => 'Locked', #WebDAV
    424 => 'Failed Dependency', #WebDAV
    425 => 'Unordered Collection', #WebDAV
    426 => 'Upgrade Required',
    449 => 'Retry With', #Microsoft
    450 => 'Blocked By Windows Parental Controls', #Microsoft

    500 => 'Internal Server Error',
    501 => 'Not Implemented',
    502 => 'Bad Gateway',
    503 => 'Service Unavailable',
    504 => 'Gateway Timeout',
    505 => 'HTTP Version Not Supported',
    506 => 'Variant Also Negotiates',
    507 => 'Insufficient Storage', #WebDAV
    509 => 'Bandwidth Limit Exceeded', #Apache
    510 => 'Not Extended'
  }

  EXCEPTIONS = {}

  UNHANDLED_RESPONSES.each do |code, class_name|
    klass = Class.new(HttpException)
    const_set class_name.gsub(" ", '').gsub("-", "").gsub("'", ""), klass
    EXCEPTIONS[code] = klass
  end

  class Client
    attr_reader :proxy

    def initialize(proxy: nil)
      @proxy = proxy
    end

    def post(location: location, body: body)
      request method: :post, location: location, body: body
    end

    def put(location: location, body: body)
      request method: :put, location: location, body: body
    end

    def get(location: location)
      request method: :get, location: location
    end

    def delete(location: location)
      request method: :delete, location: location
    end

    private
    def request(method: method, location: location, body: nil)
      begin
        if body
          response = RestClient.send(method, location, JSON.generate(body), { "Content-Type" => "application/json" }, proxy)
        else
          response = RestClient.send(method, location, { "Content-Type" => "application/json" }, proxy)
        end

        if UNHANDLED_RESPONSES[response.code]
          raise EXCEPTIONS[response.code]
        else
          Response.new(
            status: response.code,
            body: response.blank? ? nil : JSON.parse(response)
          )
        end

      rescue RestClient::UnprocessableEntity => e
        Response.new(
          status: e.http_code,
          body: JSON.parse(e.http_body)
        )

      rescue RestClient::Exception => e
        raise EXCEPTIONS[e.http_code]
      end
    end
  end
end