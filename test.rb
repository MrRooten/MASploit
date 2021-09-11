# coding: utf-8
$LOAD_PATH << './lib'
require 'utils/log.rb'
require 'masploit/net/http/httprequests'
require 'pry'
require "zlib"
request = open("./burpfile_github").read
r = RequestRawData.new request
p r.method
p r.uri
p r.http_protocol
p r.host
p r.headers
p r.data
res = r.send_request
p = res.data

