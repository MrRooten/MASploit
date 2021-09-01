require 'pp'
require 'masploit/net/ip/iputils'

class MASDriver
  def list_modules

  end
  def self.command_start(options)
    if options[0] == "vulnscan" and options.size == 2
      logger = Logger.get_logger
      vulnscan_options = options[1]
      if vulnscan_options[:list] == true
        list_modules
        return
      end

      if vulnscan_options[:listen_addr] != nil
        if vulnscan_options.key?(:url) or vulnscan_options.key?(:remote_ip) or \
            vulnscan_options.key?(:burp_file) or vulnscan_options.key?(:url_file)
          logger.error("Can not set url when setting the listen_addr args")
          return
        end
        ip = nil
        port = nil
        begin
          addr = IPUtils.new vulnscan_options[:listen_addr]
          ip = addr.get_ip
          port = addr.get_port
          print(ip,port)
        rescue IPUtils::ParseIPError => e
          logger.error("Error happen: #{e.message}")
          return
        end
      end


    end
  end
end
