require 'digest'
require 'net/http'

class WebFingerMatcher
  def initialize

  end

  def is_picture?(content)

  end

  def is_html?(content)

  end

  def is_javascript?(content)

  end


  def self.new_instance
    if @@matcher == nil
      @@matcher = WebFingerMatcher.new
    end
    @@matcher
  end

  def match_content_framework(url)

  end
end
