#!/usr/bin/env ruby

require 'rack-proxy'
require 'base64'
require 'uri'

class AuthenticatingProxy < Rack::Proxy
  def call(env)
    user, password = Base64.decode64(env['HTTP_PROXY_AUTHORIZATION'].gsub("Basic ", '')).split(":")

    if user == ENV['PROXY_USER'] && password == ENV['PROXY_PASSWORD']
      super
    else
      message = "Authorized with: #{user}/#{password}. Needed #{ENV['PROXY_USER']}/#{ENV['PROXY_PASSWORD']}"
      [401, {'Content-Type' => 'application/json', 'Content-Length' => message.length.to_s}, [message]]
    end
  end
end

run AuthenticatingProxy.new