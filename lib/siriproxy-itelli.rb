require 'cora'
require 'siri_objects'

class SiriProxy::Plugin::Itelli < SiriProxy::Plugin

    def initialize(config)
    end

    listen_for /Show details second (.*)/i do | visit |
    
        say "Opening Account: Logistik BemAT GmbH in SAP"
        
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
    
    listen_for /Show details open (.*)/i do | task |
    
    	say "Opening Task: Account 1000 in SAP"
        
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
    
   listen_for /Use (.*) and send (.*) to (.*)/i do | app, obejct, person |
	say "Find the new Priceliste attached", spoken: "Here is your message to Klaus Rainer Berger"
	
        object = SiriAddViews.new
	object.make_root(last_ref_id)
	
	answer = SiriAnswer.new("Account 1000", [SiriAnswerLine.new('logo','http://s7.directupload.net/images/130130/jdchnb9s.png'),
	SiriAnswerLine.new("Hello Klaus"),
	SiriAnswerLine.new("Please find the new priceliste attached."),
	SiriAnswerLine.new(""),
	SiriAnswerLine.new("Best regards,"),
	SiriAnswerLine.new("Oliver"),
	])
	
	object.views << SiriAnswerSnippet.new([answer])
	send_object object 
	
	response = ask "Send or Cancel?" 
	
	if (response =~ /send/i)
	say "Ok, I'm sending it."
	else  
	say "Ok, I'm closing it now."
	end
	
	say "Open Task for Account 1000 in SAP was closed."
    request_completed
    end  
    
    listen_for /How can I close (.*)/i do | deals |
    	say "Sorry I'm Siri not Hana!"  
    request_completed
    end     
    
    listen_for /Thank's for your (.*)/i do | help |
    	say "No, problem - don't forget the party tonight!"  
    request_completed
    end       
	
end
