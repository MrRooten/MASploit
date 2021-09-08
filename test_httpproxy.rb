require_relative 'lib/masploit/net/http/httpproxy'
require_relative 'lib/masploit/net/http/httprequests'

# ${uri [key [variable]]}
# ${file:///password abcdefg}
# ${file:///username abcdefg username}

def match_pattern(req,key)
  match = {}
  match.default = []
  reg = /\${\w+ ?#{key}}/

  request = {}
  request["url"] = req.request_uri
  request["headers"] = req.header
  request["body"] = req.body

  request
end

def send_request(request)

end
q_key = "123456"
class HTTPProxy
  def request_handler(req)
    request = nil
    unless (request = match_pattern(req,q_key)).nil?

    end
  end

  def response_handler(req,res)
    print(res)
  end
end
proxy = HTTPProxy.new 9999
proxy.start

trap 'INT' do proxy.shutdown end
trap 'TERM' do proxy.shutdown end

while true

end
