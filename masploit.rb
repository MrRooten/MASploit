$LOAD_PATH << './lib'
require 'optparse'
require 'clamp'
require 'pp'
require 'masploit/framework/command_dispatch'
require 'utils/log'

if __FILE__ == $0
  command_options = []
    Clamp do
      subcommand 'vulnscan', "Vuln Scanner" do
        vulnscan_options = {}
          option ["-l", "--list"], :flag, "List modules" do |value|
            vulnscan_options[:list] = value
          end
          option ["--pocs"], "pocs", "Which pocs to use" do |value|
            vulnscan_options[:pocs] = value
          end
          option ["-m", "--modules"], "modules", "Which modules to use" do |value|
            vulnscan_options[:modules] = value
          end
          option ["-u", "--url"], "url", "Scan the target url" do |value|
            vulnscan_options[:url] = value
          end
          option ["--ri", "--remote-ip"], "remote_ip", "Scan the remote ip" do |value|
            vulnscan_options[:remote_ip] = value
          end
          option ["--uf", "--url-file"], "url_file", "Scan urls of a file" do |value|
            vulnscan_options[:url_file] = value
          end
          option ["--bf", "--burp-file"], "burp_file", "Scan target reading from burp file" do |value|
            vulnscan_options[:burp_file] = value
          end
          option ["--la", "--listen-addr"], "listen_addr", "Use proxy to scan the target" do |value|
            vulnscan_options[:listen_addr] = value
          end
          option ["--ho", "--html-output"], "html_output", "Output the result to a file as html format" do |value|
            vulnscan_options[:html_output] = value
          end
          option ["--jo", "--json-output"], "json_output", "Output the result to a file as json format" do |value|
            vulnscan_options[:json_output] = value
          end
          command_options << "vulnscan"
          command_options << vulnscan_options
      end
        option ["-c", "--config"], "CONFIG", "Specify config file (Globally)"

        def execute
        end
    end

    MASDriver.command_start command_options
end
