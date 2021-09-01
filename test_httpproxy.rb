require 'webrick/httpproxy'

def handle_request(req,res)
  puts "[REQUEST]" + req.request_line
  if req.host == "example.com" || req.host == "www.example.com"
        res.header['content-type'] = 'text/html'
        res.header.delete('content-encoding')
        res.body = "Access is denied."
  end
end

if $0 == __FILE__ then
  server = WEBrick::HTTPProxyServer.new(
    :ProxyURI=>URI.parse("http://127.0.0.1:8080/"),
    :Port=>8008,
    :AccessLog=>[],
    :ProxyContentHandler=>method(:handle_request)
  )
  trap 'INT'  do server.shutdown end
  trap 'TERM' do server.shutdown end
  server.start
end
