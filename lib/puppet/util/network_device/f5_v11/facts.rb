require 'json'
require 'puppet'
require 'puppet/util/network_device/transport'
require 'puppet/util/network_device/transport/rest'

class Puppet::Util::NetworkDevice::F5_v11::Facts

  attr_accessor :transport

  def initialize(transport)
    @transport = transport
  end

  def retrieve
    @facts = {}
    #new GET command
    response = @transport.get('/mgmt/tm/cm/device')
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
      disk_response = @transport.get('/mgmt/tm/sys/disk/logical-disk')
      if disk_response.code == '200'
        disk_output = JSON.parse(disk_response.body)
        disk_output['items'].each do |y|
          @facts["disk_size_#{y['name']}"] = y['size']
          @facts["disk_free_#{y['name']}"] = y['vgFree']
        end
      end
      @facts
    else
      raise Puppet::Error, "We have some broken stuff: #{e}"
    end
  rescue Exception => e
    raise Puppet::Error, "Shit is broken mate, best you fix it: #{e}"
  end
end
