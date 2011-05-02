SyndicationFeed = class("SyndicationFeed")
local json = require ("dkjson")

SyndicationFeed.items = nil
SyndicationFeed.notCompletedQuestions = nil
SyndicationFeed.title = nil

function SyndicationFeed:initialize(title)
	SyndicationFeed.title = title
	SyndicationFeed.items = {}
	SyndicationFeed.notCompletedQuestions = {}
end

function SyndicationFeed:addItem(item)
	table.insert(SyndicationFeed.items, item)
end

function SyndicationFeed:addNotCompletedQuestionItem(item)
	table.insert(SyndicationFeed.notCompletedQuestions, item)
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
					xmlNode.question = v2.question;
					xmlNode.totalViews = v2.totalViews;
					xmlNode.answer1 = v2.answer1;
					xmlNode.answer2 = v2.answer2;
					xmlNode.answer3 = v2.answer3;
					xmlNode.answer4 = v2.answer4;
					xmlNode.answer5 = v2.answer5;
					xmlNode.answer6 = v2.answer6;
					xmlNode.qtanswer1 = v2.qtanswer1;
					xmlNode.qtanswer2 = v2.qtanswer2;
					xmlNode.qtanswer3 = v2.qtanswer3;
					xmlNode.qtanswer4 = v2.qtanswer4;
					xmlNode.qtanswer5 = v2.qtanswer5;
					xmlNode.qtanswer6 = v2.qtanswer6;
					
					local item = SyndicationItem:new(xmlNode)
					SyndicationFeed:addItem(item)
					
					xmlNode = nil;
					item = nil;
      		    end
    		else
      			--[[print (k, v)--]]
    		end
  		end
	end

end

function SyndicationFeed:getItems()
	
	for i=1, #SyndicationFeed.items do
		local item = SyndicationFeed.items[i]
		if (item.completed == 0 ) then 
			SyndicationFeed:addNotCompletedQuestionItem(item)
		end
	end
			
	return SyndicationFeed.notCompletedQuestions;
	
 --[[	for k,v in pairs(SyndicationFeed.items) do 
		print(k,v)
		if (v.completed == 0 ) then 
			SyndicationFeed:addnotCompletedQuestionItem(item)
		end
	end
	
	return SyndicationFeed.items
	
	--]]
end

function SyndicationFeed:getCurrentItem(n)
	return SyndicationFeed.notCompletedQuestions[n];
end

function SyndicationFeed:setCompleted()
	SyndicationFeed.items[1].completed = 1;
	table.remove(SyndicationFeed.notCompletedQuestions, SyndicationFeed.notCompletedQuestions[1])

end