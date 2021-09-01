require 'webrick/httpproxy'

class HTTPProxy

  def content_handler(req,res)
    print("[INFO]"+req.request_line)
    @request_queue << req
  end

  def initialize(port,req_handler,res_handler,proxy_server=nil)
    if proxy_server != nil 
      @server = WEBrick::HTTPProxyServer.new(
        :Port => port,
        :AccessLog => [],
        :ProxyContentHandler => method(:content_handler)
      )
    else
      @server = WEBrick::HTTPProxyServer.new(
        :Port => port,
        :AccessLog => [],
        :ProxyContentHandler => method(:content_handler),
        :ProxyURI => URI.parse(proxy_server)
      )
    end
    @request_queue = Queue.new


  end

  def start
    @server.start
  end

  def close_server
    @server.shutdown
  end
end
