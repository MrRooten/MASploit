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
end


# self.* is Static method which is not persistent http
# *method is the persistent method
class Request

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

  def self.get(url,params:{},headers:nil,proxy:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers).get(url,:params=>params)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).get(url,:params=>params)
    end
  end

  def get(uri,param:nil,headers:nil)
    unless @proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).get(uri,:prams=>params)
    else
      response = Response.new @http.headers(headers)
        .get(uri,:params=>params)
    end
  end

  def self.post(url,params:nil,headers:nil,data:nil,proxy:nil)
    if proxy.nil?
      response = Response.new HTTP.headers(headers)
        .post(url,:params=>params,:form=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(@host,@port)
        .headers(headers).post(url,:params=>params,:form=>data)
    end
  end

  def post(uri,params:nil,headers:nil,data:nil)
    unless @proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).post(uri,:params=>params,:form=>data)
    else
      response = Response.new @http.headers(hewaders)
        .post(uri,:params=>params,:form=>data)
    end
  end

  def self.head(url,params:nil,headers:nil,data:nil,proxy:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .head(url,:params=>params,:form=>data)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).head(url,:params=>params,:form=>data)
    end
  end

  def head(uri,params:nil,headers:nil,data:nil)
    if !proxy.nil?
      response = Response.new @http.via(@host,@port)
        .headers(headers).head(uri,:params=>params,:form=>form)
    else
      response = Response.new @http.headers(headers)
        .head(uri,:params=>params,:form=>form)
    end
  end

  def self.options(url,params:nil,headers:nil,proxy:nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .options(url,:params=>params)
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .options(url,:params=>params)
    end
  end

  def options(uri,params:nil,headers:nil,proxy:nil)
    if !proxy.nil?
      Response.new @http.via(@host,@port)
              .headers(headers).options(uri,:params=>params)
    else
      Response.new @http.headers(headers)
        .options(uri,:params=>params)
    end
  end
end
