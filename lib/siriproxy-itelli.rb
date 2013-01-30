require 'cora'
require 'siri_objects'
require 'pp'
require 'json'
require 'httparty'
require 'nokogiri'
require 'open-uri'


class SiriProxy::Plugin::Itelli < SiriProxy::Plugin
  def initialize(config)
# Instance Variables
  @sapgw_hostname = "http://bfescm42.crm-demo.de:8080/"
#Acct Variables (Stored globally so that in the event a user makes a second request
# pertaining to an account we dont need to refetch the data.
@acc_no = ""
@acc_name = ""
@acc_cat = ""
@acc_addr_no = ""
@acc_addr_street = ""
@acc_addr_city = ""
@acc_addr_region = ""
@acc_addr_country = ""
@acc_addr_zip = ""
@acc_website = ""
@acc_email = ""
end

def test_connection
#We simply fetching some data from a gateway call to ensure the system responds
#If you are using your own gateway box, I suggest connecting to
uri = "#{@sapgw_hostname}sap/opu/odata/sap/ZSD_SALES_APP/?$format=xml"
doc = Nokogiri::HTML(open(uri))
puts "Opened URL"

@response = "Connection error"

doc.xpath('//scheme_agency_id').each do |value|
@response = value.content
end
@response = "SAP Server: " + @sapgw_hostname + "<br />Company: " + @response
    return @response
end


def show_account(acctno)
uri = "#{@sapgw_hostname}sap/opu/sdata/iwcnt/account/AccountCollection(Value=%27" + acctno +"%27,Scheme_ID=%27ACCOUNT%27,Scheme_Agency_ID=%27HU4_800%27)"
doc = Nokogiri::HTML(open(uri))
puts "URL " + uri

doc.xpath('//value').each do |acc_no1|
@acc_no = acc_no1.content
end
doc.xpath('//categorytext').each do |acc_cat1|
@acc_cat = acc_cat1.content
end
doc.xpath('//organizationname').each do |acc_name1|
@acc_name = acc_name1.content
end
doc.xpath('//houseid').each do |acc_addr_no1|
@acc_addr_no = acc_addr_no1.content
end
doc.xpath('//street').each do |acc_addr_street1|
@acc_addr_street = acc_addr_street1.content
end
doc.xpath('//city').each do |acc_addr_city1|
@acc_addr_city = acc_addr_city1.content
end
doc.xpath('//countryname').each do |acc_addr_country1|
@acc_addr_country = acc_addr_country1.content
end
doc.xpath('//citypostalcode').each do |acc_addr_zip1|
@acc_addr_zip = acc_addr_zip1.content
end
doc.xpath('//regionname').each do |acc_addr_region1|
@acc_addr_region = acc_addr_region1.content
end
doc.xpath('//uri').each do |acc_website1|
@acc_website = acc_website1.content
end
doc.xpath('//email').each do |acc_email1|
@acc_email = acc_email1.content
end

object = SiriAddViews.new
object.make_root(last_ref_id)

puts "read file"

answer = SiriAnswer.new("Account:" + @acc_no, [SiriAnswerLine.new('logo','http://li-labs.com/images/Siri.png'),

SiriAnswerLine.new(@acc_name),
SiriAnswerLine.new(@acc_cat),
    SiriAnswerLine.new("--------------------------------------"),
 
SiriAnswerLine.new(@acc_email),
SiriAnswerLine.new(@acc_website),
    SiriAnswerLine.new("--------------------------------------"),

SiriAnswerLine.new(@acc_addr_no + " " + @acc_addr_street),
SiriAnswerLine.new(@acc_addr_city + ", " + @acc_addr_country),
SiriAnswerLine.new(@acc_addr_zip + " " + @acc_addr_region)
])

     object.views << SiriAnswerSnippet.new([answer])
send_object object
end

def show_account_name(acctno)
uri = "#{@sapgw_hostname}sap/opu/sdata/iwcnt/account/AccountCollection(Value=%27" + acctno + "%27,Scheme_ID=%27ACCOUNT%27,Scheme_Agency_ID=%27HU4_800%27)"
doc = Nokogiri::HTML(open(uri))
puts "URL " + uri

@acc_no = acctno

doc.xpath('//organizationname').each do |acc_name1|
@acc_name = acc_name1.content
end

say "Der Name des Kunden mit der Nummer" + @acc_no + " ist " + @acc_name

end


def show_map (object_name)
#Method does not work correctly
add_views = SiriAddViews.new
add_views.make_root(last_ref_id)
map_snippet = SiriMapItemSnippet.new
#map_snippet.items << SiriMapItem.new
siri_location = SiriLocation.new(@acc_name, @acc_addr_no + " " + @acc_addr_street, @acc_addr_city, @acc_addr_region,
        @acc_addr_country, @acc_addr_zip)
map_snippet.items << SiriMapItem.new(@acc_name, siri_location, "FRIEND_ITEM")
add_views.views << map_snippet
    
send_object add_views
end

#Listeners section

listen_for /Show me my planned appointments today/i do

say "09:30 Visit, Alibaba Verlag" + "13:30 Visit, Logistik BemAT GmbH" + "16:00 Visit, Steinbach Communications" + "20:00 Kickoff Party - till drunk", spoken: "OK, Oliver, I found four appointments for today"

request_completed

end

listen_for /Finde SAP in Bielefeld/i do
say "Suche itelligence Gateway, einen Moment bitte"
    
Thread.new {
t = test_connection
object = SiriAddViews.new
object.make_root(last_ref_id)
say "Connection to itelligence Gateway is succesful"
answer = SiriAnswer.new(t)
object.views << SiriAnswerSnippet.new([answer])
send_object object

request_completed
}
end

listen_for /Hallo Siri/i do
say "Hallo Ludwig"
end

listen_for /Starte (.*)/i do |userAction|
    while userAction.empty? do
    userAction = ask "What program?"
    end
`osascript -e 'tell application "#{userAction.chop}" to activate'`
say "Opening #{userAction.chop}."
    request_completed
end

listen_for /Sing mir ein Lied/i do
response = ask "Gerne, ein Weihnachtslied?" 

if (response =~ /ja/i)
say "Oh du froehliche, oh du sehlige", spoken: "Oh du froehliche, oh du sehlige" + " Gnadenbringende Weihnachtszeit." + " Welt ging verloren," + " Christ ward geboren," + " Freue, freue dich," + " O Christenheit!"
else  
say "I'm on the highway to hell", spoken: "I'm on the highway to hell" + " On the highway to hell" + " Highway to hell" + " I'm on the highway to hell"
end

end

listen_for /Frohe Weihnachten/i do

say "Das wuensche ich dir auch!", spoken: "Bis im neuen Jahr 2013"

end

listen_for /test/i do
object = SiriAddViews.new
object.make_root(last_ref_id)

answer = SiriAnswer.new("Itelligence", [SiriAnswerLine.new('logo','http://www.itelligence.de/images/itelligence-logo.gif'),

SiriAnswerLine.new("itelligence AG"),
SiriAnswerLine.new("--------------------------------------"),
SiriAnswerLine.new("SiriProxy"),
])

object.views << SiriAnswerSnippet.new([answer])
send_object object
end


listen_for /(open|show) (account|company) details/i do
response = "no"
if (@acc_no)
response = ask "For " + @acc_name + "?"	
end

if (response =~ /yes/i)
acctno = @acc_no
else	
acctno = ask "OK, for which account?" #ask the user for account number
acctno.strip!
     end

say "Opening account: " + acctno + " ", spoken: "Opening account"

if (acctno) #process their response
Thread.new {
show_account(acctno)
request_completed
}
end
end

listen_for /show map for (.*)/i do | accntname |
say "OK, I will check for you"
Thread.new {
acctname.strip!
show_map (object_name)
request_completed
}

end

listen_for /Zeige Kundenstammsatz/i do
kunnr = ask "OK, welche Kundennummer?" #Frage nach Kundennummer
say "Prüfe Kundennummer: " + kunnr, spoken: "Prüfe"

Thread.new {
kunnr.strip!
show_account_name (kunnr)

request_completed
}
end

listen_for /Hallo Hanna/i do
say "Mein Name ist Siri, nicht HANA."
end
end
