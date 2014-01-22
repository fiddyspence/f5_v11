require 'uri'
require 'puppet/util/network_device/f5v11/facts'

class Puppet::Util::NetworkDevice::F5v11::Device

  attr_accessor :url, :transport, :partition

  def initialize(url, option = {})
    puts "Start of device"
    @url = URI.parse(url)
    @option = option
  end


end
