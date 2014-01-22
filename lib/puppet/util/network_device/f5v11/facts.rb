require 'net/https'
require 'uri'
require 'json'
require 'puppet'

module Puppet::Util::NetworkDevice::F5v11::Facts

  attr_accessor :username, :password, :host

  def self.retrieve
    @facts = {}

    if ! host.gsub(/https/)
      host = "https://#{host}"
    end
    uri = URI.parse("#{host}")

    #new http connection and let's make it ssl
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    http.verify_node = OpenSSL::SSL::VERIFY_NONE

    #new GET command
    request = Net::HTTP::Get.new('/mgmt/tm/cm/device')
    request.basic_auth(:username,:password)
    if response.code == 200
      response = http.request(request)
      pre_output = JSON.parse(response.body)
      output = pre_output['items']

      #format and find
      #we are only going to do the first device in the array, not all
      @facts = {}
      output['items'].each do |x|
      if y['selfDevice'] == 'true'
        @facts["name"] = y['name']
        @facts["hostname"] =  y['hostname']
        @facts["ipaddress"] = y['managementIp']
        @facts["version"] = y['version']
        @facts["base_mac_address"] = y['baseMac']
        @facts["platformId"] = y['platformId']
      end
      disk_request = Net::HTTP::Get.new('/mgmt/tm/sys/disk/logical-disk')
      disk_request.basic_auth(:username,:password)
      disk_output = JSON.parse(disk_response)
      if response.code == '200'
        disk_output['items'].each do |y|
          @facts["disk_size_#{y['name']}"] = y['size']
          @facts["disk_free_#{y['name']}"] = y['vgfree']
        end
      end
    end
    else
      puts "20 degrees bow up, ahead revolutions 115, emergency surface the submarine!"
    end
  rescue Exception => e
    puts "Shit is broken mate, best you fix it"
  end
end
