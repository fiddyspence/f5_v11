require 'uri'
require 'puppet'
require 'puppet/util'
require 'puppet/util/network_device/base'
require 'puppet/util/network_device/f5_v11'
require 'puppet/util/network_device/f5_v11/facts'

class Puppet::Util::NetworkDevice::F5_v11::Device

  attr_accessor :url, :transport, :partition

  def initialize(url, option = {})
    @url = URI.parse(url)
    @option = option
  end

  def facts
    @facts ||= Puppet::Util::NetworkDevice::F5_v11::Facts.new(url)
    facts = {}
    #command do |ng|
      facts = @facts.retrieve
    #end
    facts
  end


end
