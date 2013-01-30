require 'cora'
require 'siri_objects'
require 'pp'
require 'json'
require 'httparty'
require 'nokogiri'
require 'open-uri'

class SiriProxy::Plugin::Itelli < SiriProxy::Plugin

    def initialize(config)
    end

    listen_for /The hubs last message/i do
    page = HTTParty.get('https://status.github.com/api/last-message.json').body
    reply = JSON.parse(page)
    
        say "The last message was: #{reply["body"]}. The status then was '#{reply["status"]}' and that was at #{reply["created_on"]}"
    
    request_completed
    end

  listen_for /Show me my planned appointments today/i do
		say "09:30 Visit, Alibaba Verlag" + "13:30 Visit, Logistik BemAT GmbH" + "16:00 Visit, Steinbach Communications" + "20:00 Kickoff Party - till drunk", spoken: "OK, Oliver, I found four appointments for today"

	request_completed
	end
	
end
