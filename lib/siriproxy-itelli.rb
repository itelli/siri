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
	
	answer = SiriAnswer.new("Account 1000", [SiriAnswerLine.new('logo','http://s7.directupload.net/images/130130/jdchnb9s.png'),
	SiriAnswerLine.new("Logistik BemAT GmbH"),
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
    
    listen_for /Show details open task/i do
    
    	spoken "Opening Task: Account 1000 in SAP"
        
	object = SiriAddViews.new
	object.make_root(last_ref_id)
	
	answer = SiriAnswer.new("Account 1000", [SiriAnswerLine.new('logo','http://s7.directupload.net/images/130130/jdchnb9s.png'),
	SiriAnswerLine.new("Logistik BemAT GmbH"),
	SiriAnswerLine.new("Task Due Date: 31.01.2013"),
	SiriAnswerLine.new("Priority: High"),
	SiriAnswerLine.new("Description: Send new Pricelist"),
	SiriAnswerLine.new("--------------------------------------"),
	SiriAnswerLine.new("Contact Person: Klaus Rainer Berger"),
	])
	
	object.views << SiriAnswerSnippet.new([answer])
	send_object object        
        
    request_completed
    end    
    
   listen_for /Open SalesKit and send Pricelist to Contact Person /i do
	say "Find the new Priceliste attached", spoken: "Here is your message to Klaus Rainer Berger"
	
	response = ask "Send or Cancel?" 
	
	if (response =~ /send/i)
	say "Ok, I sent it."
	else  
	say "Ok, i close it now."
	end
	
	say "Open Task for Account 1000 in SAP was closed."
    request_completed
    end    
	
end
