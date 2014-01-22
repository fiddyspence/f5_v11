require 'net/https'
require 'uri'
require 'json'
require 'puppet'

class Puppet::Util::NetworkDevice::F5_v11::Facts

  attr_accessor :username, :password, :host, :url

  def initialize(url)
    @url = url
  end

  def retrieve
    @facts = {}
    @username = url.user
    @password = url.password
    @host = url.host
    uri = URI.parse("https://#{host}")

    #new http connection and let's make it ssl
    http = Net::HTTP.new(uri.host,uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    #new GET command
    request = Net::HTTP::Get.new('/mgmt/tm/cm/device')
    request.basic_auth(username,password)
    response = http.request(request)
    if response.code == '200'
      pre_output = JSON.parse(response.body)

      #format and find
      #we are only going to do the first device in the array, not all
      pre_output['items'].each do |y|
        if y['selfDevice'] == 'true'
          @facts["name"] = y['name']
          @facts["hostname"] =  y['hostname']
          @facts["ipaddress"] = y['managementIp']
          @facts["version"] = y['version']
          @facts["base_mac_address"] = y['baseMac']
          @facts["platformId"] = y['platformId']
        end
      end
      disk_request = Net::HTTP::Get.new('/mgmt/tm/sys/disk/logical-disk')
      disk_request.basic_auth(username,password)
      disk_response = http.request(disk_request)
      puts disk_response.code
      if disk_response.code == '200'
        disk_output = JSON.parse(disk_response.body)
        disk_output['items'].each do |y|
          @facts["disk_size_#{y['name']}"] = y['size']
          @facts["disk_free_#{y['name']}"] = y['vgFree']
        end
      end
      puts @facts
    else
      puts "20 degrees bow up, ahead revolutions 115, emergency surface the submarine!"
    end
  rescue Exception => e
    puts "Shit is broken mate, best you fix it: #{e}"
  end
end
