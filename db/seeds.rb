# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
  name = shell.ask("What's your name?")
  shell.say name

email     = shell.ask "Which email do you want use for logging into admin?"
password  = shell.ask "Tell me the password to use:"

shell.say ""

account = Account.create(:email => email, :name => "Foo", :surname => "Bar", :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

# shell.say ""
# require "rexml/document" 
# xml3=File.open('street.xml')
# doc3=REXML::Document.new(xml3)
# doc3.elements.each("xml/street"){|e|
#       area=Area.where(name:e.elements['area'].text).first
#       street=Street.new
#       street.area=area
#       street.name=e.elements["name"].text
#       street.save
# }

# xml=File.open("node.xml")

# doc = REXML::Document.new(xml) 
# doc.elements.each("xml/node") { |e|
# 	city=City.where(name:e.elements['city'].text).first
# 	area=Area.where(name:e.elements['area'].text).first
#  	node=Node.new
#  	node.city=city
#  	node.area=area
#  	node.code=e.elements['number'].text
#  	node.name=e.elements['name'].text
#         streets=e.elements['streets'].text.split(',')
#         node.streets=streets
#  	node.save
#   }  

#   xml2=File.open('nodeway.xml')
#   doc2=REXML::Document.new(xml2)
#   doc2.elements.each("xml/nodeway"){|e|
#   	node=Node.where(code:e.elements['node'].text).first
#         tonode=Node.where(code:e.elements['tonode'].text).first
#   	nodeway=NodeWay.new
#   	nodeway.node=node
#   	nodeway.tonode=tonode._id
#   	nodeway.time=e.elements['time'].text
#   	nodeway.save
#   }
