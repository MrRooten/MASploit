class IPUtils
  @@ippattern = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
  def initialize(ipport)
    tmp = ipport.split(":")
    if tmp.size != 2
      raise ParseIPError.new "Can't split the ip port by ':'"
    end

    @ip = tmp[0].strip
    unless IPUtils.is_valid_ip?(@ip)
      raise ParseIPError.new "The ip is not a valid pattern:#{tmp[0]}"
    end

    @port = tmp[1].to_i
    unless IPUtils.is_valid_port?(@port) and (tmp[1] =~ /\A\d+\Z/)
      raise ParseIPError.new "The port is not a valid pattern:#{tmp[1]}"
    end
  end

  def get_ip
    @ip
  end

  def get_port
    @port
  end

  def self.is_valid_ip?(ip)
    if ip.class != String
      return false
    end

    if (ip =~ @@ippattern) == nil
      return false
    end

    return true
  end

  def self.is_valid_port?(port)
    if port.class != Integer
      return false
    end

    if port < 0 or port > 65535
      return false
    end

    return true
  end

  class ParseIPError < StandardError
    attr_reader :message

    def initialize(message)
      super(message)
	  @message = message
    end
  end
end
