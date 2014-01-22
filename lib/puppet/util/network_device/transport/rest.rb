require 'net/https'
require 'uri'
require 'json'
require 'puppet/util/network_device'
require 'puppet/util/network_device/transport'
require 'puppet/util/network_device/transport/base'

class Puppet::Util::NetworkDevice::Transport::Rest < Puppet::Util::NetworkDevice::Transport::Base

  attr_accessor :http, :username, :password, :host, :url

  def initialize(url)
    @url = URI.parse(url)
    super() #got to check why I need to do this
    @username = @url.user
    @password = @url.password
    @host = @url.host
    uri = URI.parse("https://#{host}")

    #new http connection and let's make it ssl
    @http = Net::HTTP.new(uri.host,uri.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  def get(path)
    request = Net::HTTP::Get.new(path)
    request.basic_auth(@username,@password)
    response = @http.request(request)
    response
  rescue Exception => e
    raise Puppet::Error, "Broken in GET: #{e}"
  end

  def post(path,content)
    request = Net::HTTP::Post.new(path)
    request.body = content.to_json
    request["Content-Type"] = "application/json"
    request.basic_auth(@username,@password)
    response = @http.request(request)
    response
  rescue Exception => e
    raise Puppet::Error, "Broken in POST: #{e}"
  end

  def delete(path)
    request = Net::HTTP::Delete.new(path)
    request.basic_auth(@username,@password)
    response = @http.request(request)
    response
  rescue Exception => e
    raise Puppet::Error, "Broken in DELETE: #{e}"
  end
end
