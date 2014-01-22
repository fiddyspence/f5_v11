require 'puppet/util/network_device/f5_v11/device'

class Puppet::Provider::F5_v11 < Puppet::Provider

  def self.transport
    if Facter.value(:url) then
      Puppet.debug "Puppet::Util::NetworkDevice::F5_v11: connecting via facter url."
      @device ||= Puppet::Util::NetworkDevice::F5_v11::Device.new(Facter.value(:url))
    else
      @device ||= Puppet::Util::NetworkDevice.current
      raise Puppet::Error, "Puppet::Util::NetworkDevice::F5_v11: device not initialized #{caller.join("\n")}" unless @device
    end

    @tranport = @device.transport
  end

  def transport
    # this calls the class instance of self.transport instead of the object instance which causes an infinite loop.
    self.class.transport
  end
end
