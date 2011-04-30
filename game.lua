module(..., package.seeall)

require("middleclass")
require("Lib_XmlParser")

-- Classes
require("Data_UrlLoader")
require("Rss_SyndicationFeed")
require("Rss_SyndicationItem")

function new()
	local g = display.newGroup()
	
	local callback = function(rss)
		local syndication = SyndicationFeed:new("NRK Feed")
		syndication:parseFeed(rss)

		local items = syndication:getItems()
		for i=1, #items do
			local item = items[i]
			print(i .. "-" .. item.name);
		
			local itemGroup = display.newGroup()
			local title = display.newText(item.name, 10, 10, "Helvetica", 16)
			itemGroup:insert(title)
			itemGroup.y = 10 + (40 * (i-1))
			g:insert(itemGroup) 
		end
	end
	
	UrlLoader:new("http://localhost/rest_api/public/global/format/json", callback)
	
	return g
end