# coding: utf-8
$LOAD_PATH << './lib'
require 'utils/log.rb'
require 'masploit/net/http/httprequests'
require 'pry'
require "zlib"
request = open("./burpfile_nn8z").read
body = (Request.send_from_request request).body
conn = Zlib::GzipReader.new(StringIO.new(body))
unzipped = conn.read
conn.close
p unzipped
