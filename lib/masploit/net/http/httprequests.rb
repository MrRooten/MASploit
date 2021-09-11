require 'http'
require 'pry'

class Response

  def initialize(response)
    @response = response
  end

  def status_code
    @response.status
  end

  def headers
    if @headers == nil
      @headers = @response.headers.to_hash
    end
  end
  def data(size:-1)
    if size == -1
      @response.body.to_s
    else
      @response.body.readpartial size
    end
  end

  def deflate_data

  end
end


class RequestRawData
  def initialize bytes,is_ssl:false
    @bytes = bytes
    @method = nil
    @uri = nil
    @host = nil
    @headers = nil
    @data = nil
    @is_ssl = is_ssl
    @http_protocol = nil
  end

  def send_request(proxy:nil)
    http_protocol = self.http_protocol
    method = self.method
    host = self.host
    uri = self.uri
    request_uri = (@is_ssl?"https://":"http://") + host + uri
    headers = self.headers
    data = self.data
    if proxy.class == Array
    elsif proxy.class == String
      host,port = proxy.split(":")
      port = port.to_i
      proxy = [host,port]
    end
    method = method.downcase!
    Request.send(method,request_uri,:data=>data,:headers=>headers,:proxy=>proxy)
  end

  def is_ssl
    @is_ssl
  end

  def http_protocol
    if @http_protocol != nil
      @http_protocol
    else
      tmp = @bytes[0,@bytes.index("\r\n")]
      @http_protocol = tmp.split(" ")[2]
      @http_protocol
    end
  end

  def host
    if @host != nil
      @host
    else
      @headers = headers
      @headers['host']
    end
  end

  def method
    if @method != nil
      @method
    else
      tmp = @bytes[0,@bytes.index("\r\n")]
      @method = tmp.split(" ")[0]
      @method.strip!
      @method
    end
  end

  def uri
    if @uri != nil
      @uri
    else
      tmp = @bytes.split("\r\n")[0]
      @uri = tmp.split(" ")[1]
      @uri.strip!
      @uri
    end
  end

  def headers
    if @headers != nil
      @headers
    else
      tmp = @bytes.split("\r\n\r\n")[0]
      headers = tmp.split("\r\n")[1..]
      @headers = {}
      for header in headers
        key = header[0,header.index(":")]
        value = header[(header.index(":")+1)..]
        key.strip!
        value.strip!
        key.downcase!
        @headers[key] = value
      end
      @headers
    end
  end

  def data
    if @data != nil
      @data
    else
      tmp = @bytes.split("\r\n\r\n")[1..].join
      if tmp == nil
        return nil
      end

      @data = tmp
      @data
    end
  end

  class RequestParseError < StandardError
    attr_reader :message

    def initialize message
      super(message)
      @message = message
    end
  end
end
# self.* is Static method which is not persistent http
# *method is the persistent method
class Request

  class ParseRequestError < StandardError
    attr_reader :message

    def initialize message
      super(message)
      @message = message
    end
  end
  @@req = nil
  def initialize(url,proxy=nil)
    @url = url
    @proxy = proxy
    unless proxy.nil?
      @host = @proxy[0]
      @port = @proxy[1]
    end
    @http = HTTP.persistent url
  end

  def self.send_from_request request,proxy:nil
    tmp = request_bytes.split "\r\n\r\n"

    data = request.data
    uri = request.uri
    headers = request.headers
    method = request.method
    http_protocol = request.http_protocol
    host = request.host

    logger = Logger.get_logger
    if uri.nil?
      logger.error "The uri of request is not valid"
    end

    if headers.nil?
      logger.error "The header of request is not valid"
    end

    if data.nil?
      logger.error "The data of request is not valid"
    end

    method = uri[0,uri.index(" ")].downcase #Get the method of request
    url = (request.is_ssl?"https://":"http://") + host + uri
    self.send(method,url,:headers=>headers,:proxy=>proxy,:data=>data)
  end

  def self.get(url,params:{},headers:nil,proxy:nil,data:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers).get(url,:params=>params,:body=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).get(url,:params=>params,:body=>data)
    end
  end

  def get(uri,param:nil,headers:nil,data:nil,proxy:nil)
    unless @proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).get(uri,:prams=>params,:body=>data)
    else
      response = Response.new @http.headers(headers)
        .get(uri,:params=>params,:body=>data)
    end
  end

  def self.post(url,params:nil,headers:nil,data:nil,proxy:nil)
    if proxy.nil?
      response = Response.new HTTP.headers(headers)
        .post(url,:params=>params,:body=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(@host,@port)
        .headers(headers).post(url,:params=>params,:body=>data)
    end
  end

  def post(uri,params:nil,headers:nil,data:nil)
    unless @proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).post(uri,:params=>params,:body=>data)
    else
      response = Response.new @http.headers(hewaders)
        .post(uri,:params=>params,:body=>data)
    end
  end

  def self.head(url,params:nil,headers:nil,data:nil,proxy:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .head(url,:params=>params,:body=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).head(url,:params=>params,:body=>data)
    end
  end

  def head(uri,params:nil,headers:nil,data:nil)
    if !proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).head(uri,:params=>params,:body=>data)
    else
      response = Response.new @http.headers(headers)
        .head(uri,:params=>params,:body=>data)
    end
  end

  def self.options(url,params:nil,headers:nil,proxy:nil,data:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .options(url,:params=>params,:body=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .options(url,:params=>params,:body=>data)
    end
  end

  def options(uri,params:nil,headers:nil,proxy:nil,data:nil)
    if !proxy.nil?
      Response.new @http.via(@host,@port)
              .headers(headers).options(uri,:params=>params,:body=>data)
    else
      Response.new @http.headers(headers)
        .options(uri,:params=>params,:body=>data)
    end
  end
end
