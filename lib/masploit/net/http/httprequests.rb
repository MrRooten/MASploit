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
  def body(size:-1)
    if size == -1
      @response.body.to_s
    else
      @response.body.readpartial size
    end
  end

  def deflate_body

  end
end


class RequestRawData
  def initialize bytes,is_ssl:false
    @bytes = bytes
    @uri = nil
    @host = nil
    @headers = nil
    @body = nil
  end

  def host

  end

  def uri
    if @uri != nil
      @uri
    else
      tmp = @bytes.split("\r\n")[0]
      @uri
    end
  end

  def headers

  end

  def body

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


  def self.send_from_request request_bytes,proxy:nil
    tmp = request_bytes.split "\r\n\r\n"
    body = tmp[1..]
    data = body.join
    uri = tmp[0].split("\r\n")[0]
    headers = tmp[0].split("\r\n")
    headers_list = headers[1..]

    logger = Logger.get_logger
    if uri.nil?
      logger.error "The uri of request is not valid"
    end

    if headers.nil?
      logger.error "The header of request is not valid"
    end

    if body.nil?
      logger.error "The body of request is not valid"
    end

    method = uri[0,uri.index(" ")].downcase #Get the method of request
    url = uri[uri.index(" ")..] #Get the request url
    headers_map = {}
    for header in headers_list
      key = header[0,header.index(":")]
      value = header[(header.index(":")+1)..]
      value.strip!
      if key.nil?
        raise ParseRequestError.new "Header is invalid"
      end

      if value.nil?
        raise ParseRequestError.new "Header is invalid"
      end
      key.downcase!
      headers_map[key] = value
    end

    host = headers_map["host"]
    host.strip!
    targeturi = url.split(" ")[0]
    url = "http://" + host + targeturi
    print(url,"\n")
    binding.pry
    self.send(method,url,:headers=>headers_map,:proxy=>proxy,:data=>data)
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
