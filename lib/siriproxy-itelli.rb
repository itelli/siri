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

    listen_for /Show keyfigures second visit/i do
    
        spoken: "Opening Account: Logistik BemAT GmbH in SAP"
        
	object = SiriAddViews.new
	object.make_root(last_ref_id)
	
	answer = SiriAnswer.new("Account 1000", [SiriAnswerLine.new('logo','http://www.itelligence.de/images/itelligence-logo.gif'),
	
	SiriAnswerLine.new("Logistik BemAT GmbH")
	SiriAnswerLine.new("Customer Group A"),
	SiriAnswerLine.new("Revenew last year 2,11 Mio EUR"),
	SiriAnswerLine.new("Revenew actual year 1,23 Mio. EUR"),
	SiriAnswerLine.new("--------------------------------------"),
	SiriAnswerLine.new("Open items overdue: 8.323 EUR"),
	SiriAnswerLine.new("--------------------------------------"),
	SiriAnswerLine.new("2 Open Opportunities: 70 TEUR"),
	SiriAnswerLine.new("1 Open Task Priority High"),
	])
	
	object.views << SiriAnswerSnippet.new([answer])
	send_object object        
        
    request_completed
    end
	
end
