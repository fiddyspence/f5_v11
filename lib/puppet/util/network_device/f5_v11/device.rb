require 'uri'
require 'puppet/util/network_device/f5_v11/facts'

class Puppet::Util::NetworkDevice::F5_v11::Device

  attr_accessor :url, :transport, :partition

  def initialize(url, option = {})
    @url = URI.parse(url)
    @option = option
  end


end
