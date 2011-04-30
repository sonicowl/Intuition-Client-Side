SyndicationFeed = class("SyndicationFeed")
local json = require ("dkjson")

SyndicationFeed.items = nil
SyndicationFeed.title = nil

function SyndicationFeed:initialize(title)
	SyndicationFeed.title = title
	SyndicationFeed.items = {}
end

function SyndicationFeed:addItem(item)
	table.insert(SyndicationFeed.items, item)
end

function SyndicationFeed:parseFeed(xml)

	local obj, pos, err = json.decode (xml, 1, nil)
		if err then
  			print ("Error:", err)
		else
  		for k,v in pairs(obj) do
    		if type (v) == "table" then
      			for k2,v2 in pairs(v) do
					local xmlNode = {}
					xmlNode.id = v2.id;
					xmlNode.name = v2.name;
	
					local item = SyndicationItem:new(xmlNode.name)
					
				--[[ print ("SyndicationFeed" .. item.id .. " " .. item.name); --]]
					
					SyndicationFeed:addItem(item)
					xmlNode = nil;
					item = nil;
      		    end
    		else
      			--[[print (k, v)--]]
    		end
  		end
	end


--[[	local parsed = XmlParser:ParseXmlText(xml)
	local channel = XmlParser:XmlNodes(parsed, "channel")
	local syndicationFeed = SyndicationFeed:new("NRK")
	
	for i, xmlNode in ipairs(channel) do
		if xmlNode.Name == "item" then
			local item = SyndicationItem:new(xmlNode)
			SyndicationFeed:addItem(item)
		end
	end --]]
end

function SyndicationFeed:getItems()
 	for k,v in pairs(SyndicationFeed.items) do print('aaaa' .. k,v.name) end
	
	return SyndicationFeed.items
end

function SyndicationFeed:getItem(i)
	return SyndicationFeed.items[i]
end