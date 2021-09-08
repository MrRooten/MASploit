require_relative 'lib/masploit/net/http/httpproxy'

def match_filepattern

end

class HTTPProxy
  def content_handler(req,res)
    print("[URL]" + req.request_method)
    #print("[HEADERS]" + req.raw_header.inspect)
    p req.class
  end
end

proxy = HTTPProxy.new 9999,:proxy_server=>"http://127.0.0.1:8080"
proxy.start
