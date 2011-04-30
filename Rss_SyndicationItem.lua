SyndicationItem = class("SyndicationItem")

SyndicationItem.id = nil
SyndicationItem.name = nil

function SyndicationItem:initialize(name)


	self.name = name;
		
	--[[ self.title = XmlParser:XmlValue(node, "title")
	self.link = XmlParser:XmlValue(node, "link")
	self.description = XmlParser:XmlValue(node, "description")
	self.updatedDate = XmlParser:XmlValue(node, "a10:updated")
	
	local enclosure = XmlParser:XmlAttributes(node, "enclosure")
	if enclosure then self.enclosureUrl = enclosure.url end
	--]]
end