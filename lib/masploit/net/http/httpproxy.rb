require 'ritm'

class HTTPProxy

  def request_handler(req) ;end

  def response_handler(req,res) ;end
  def initialize(port,proxy_server:nil)
    @session = Ritm::Session.new
    @session.configure do
      proxy[:bind_port] = port
      misc[:upstream_proxy] = proxy_server
    end
  end

  def start
    @session.start
    @session.on_request do |req|
      request_handler req
    end

    @session.on_response do |req,res|
      response_handler req,res
    end
  end

  def close_server
    @session.shutdown
  end
end
