# coding: utf-8
$LOAD_PATH << './lib'
require 'utils/log.rb'
require 'masploit/net/ip/iputils'
begin
  IPUtils.new("123.123.123.123")
rescue IPUtils::ParseIPError => e
  puts "ParseIPError #{e.message}"
end
