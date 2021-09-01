require 'net/http'
class Response
  def initailize(response)
    @response = response
  end

  def status_code
    @response.status
  end

  def headers
    if @headers == nil
      @headers = @response.headers.to_hash
  end

  def body
    @response.body.to_s
  end
end


# self.* is Static method which is not persistent http
# *method is the persistent method
class Request

  @@req = nil
  def initialize url,proxy=nil
    @url = url
    @proxy = proxy
    @host = @proxy[0]
    @port = @proxy[1]
    @http = HTTP.persistent url
  end

  def self.new_instance proxy=nil
    @proxy = proxy
    @host = @proxy[0]
    @port = @proxy[1]
  end

  def self.get(url,params={},headers=nil,proxy)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .get(url,:params=>params)
      return response
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).get(url,:params=>params)
      return response
    end
  end

  def get(uri,params=nil,headers=nil)
    if @proxy != nil
      response = Response.new @http.via(@host,@port)
        .headers(headers).get(uri,:prams=>params)
      return response
    else
      response = Response.new @http.headers(headers)
        .get(uri,:params=>params)
      return response
    end
  end

  def self.post(url,params=nil,headers=nil,data=nil,proxy=nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .post(url,:params=>params,:form=>data)
      return response
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(@host,@port)
        .headers(headers).post(url,:params=>params,:form=>data)
      return response
    end
  end

  def post(uri,params=nil,headers=nil,data=nil)
    if @proxy != nil
      response = Response.new @http.via(@host,@port)
        .headers(headers).post(uri,:params=>params,:form=>data)
    else
      response = Response.new @http.headers(hewaders)
        .post(uri,:params=>params,:form=>data)
    end
  end

  def self.head(url,params=nil,headers=nil,data=nil,proxy=nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .head(url,:params=>params,:form=>data)
      return response
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .headers(headers).head(url,:params=>params,:form=>data)
      return response
    end
  end

  def head(uri,params=nil,headers=nil,data=nil)
    if peoxy != nil
      response = Response.new @http.via(@host,@port)
        .headers(headers).head(uri,:params=>params,:form=>form)
      return response
    else
      response = Response.new @http.headers(headers)
        .head(uri,:params=>params,:form=>form)
      return response
    end
  end

  def self.options(url,params=nil,headers=nil,proxy=nil)
    if proxy == nil
      response = Response.new HTTP.headers(headers)
        .options(url,:params=>params)
      return response
    else
      host = proxy[0]
      port = proxy[1]
      response = Response.new HTTP.via(host,port)
        .options(url,:params=>params)
      return response
    end
  end

  def options(uri,params=nil,headers=nil,proxy=nil)
    if proxy != nil
      response = Response.new @http.via(@host,@port)
        .headers(headers).options(uri,:params=>params)
      return response
    else
      response = Response.new @http.headers(headers)
        .options(uri,:params=>params)
      return response
    end
  end

end
