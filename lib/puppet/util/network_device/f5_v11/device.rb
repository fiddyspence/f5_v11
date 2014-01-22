require 'uri'
require 'puppet'
require 'puppet/util'
require 'puppet/util/network_device/base'
require 'puppet/util/network_device/f5_v11'
require 'puppet/util/network_device/f5_v11/facts'
require 'puppet/util/network_device/transport'
require 'puppet/util/network_device/transport/rest'

class Puppet::Util::NetworkDevice::F5_v11::Device

  attr_accessor :url, :transport, :partition

  def initialize(url, option = {})
    @url = URI.parse(url)
    @option = option

    @transport ||= Puppet::Util::NetworkDevice::Transport::Rest.new(url)

    # Access Common partition by default:
    if @url.path == '' or @url.path == '/'
      @partition = 'Common'
    else
      @partition = /\/(.*)/.match(@url.path).captures
    end
  rescue Exception => e
    raise Puppet::Error, "You have seriously broken this thing #{e}"
  end

  def facts
    @facts ||= Puppet::Util::NetworkDevice::F5_v11::Facts.new(@transport)
    facts = @facts.retrieve

    # inject F5 partition info.
    facts['partition'] = @partition
    facts
  end


end
