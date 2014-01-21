require 'puppet'
require 'puppet/util/network_device/f5_v11/device'

class Puppet::Util::NetworkDevice::F5_v11

  attr_accessor :url, :transport, :partition

  def initialize(url, option = {})
    @url = URI.parse(url)
    @option = option

    unless @transport 
      if Facter.value(:url) then
        Puppet.debug "Puppet::Util::NetworkDevice::F5: connecting via facter url."
        @device ||= Puppet::Util::NetworkDevice::F5_v11::Device.new(Facter.value(:url))
      else
        @device ||= Puppet::Util::NetworkDevice.current
        raise Puppet::Error, "Puppet::Util::NetworkDevice::F5_v11: device not initialized #{caller.join("\n")}" unless @device
      end

      @tranport = @device.transport
    end

end
