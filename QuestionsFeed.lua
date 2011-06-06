QuestionsFeed = class("QuestionsFeed")
local json = require ("dkjson")

QuestionsFeed.items = nil
QuestionsFeed.notCompletedQuestions = nil
QuestionsFeed.title = nil

function QuestionsFeed:initialize(title)
	QuestionsFeed.title = title
	QuestionsFeed.items = {}
	QuestionsFeed.notCompletedQuestions = {}
end

function QuestionsFeed:addItem(item)
	table.insert(QuestionsFeed.items, item)
end

function QuestionsFeed:addNotCompletedQuestionItem(item)
	table.insert(QuestionsFeed.notCompletedQuestions, item)
end

function QuestionsFeed:parseFeed(xml)

	local obj, pos, err = json.decode (xml, 1, nil)
		if err then
  			print ("Error:", err)
		else
  		for k,v in pairs(obj) do
    		if type (v) == "table" then
      			for k2,v2 in pairs(v) do
					local jsonObj = {}
					jsonObj.id = v2.id;
					jsonObj.question = v2.question;
					jsonObj.totalViews = v2.totalviewsfake;
					jsonObj.answer1 = v2.answer1;
					jsonObj.answer2 = v2.answer2;
					jsonObj.answer3 = v2.answer3;
					jsonObj.answer4 = v2.answer4;
					jsonObj.answer5 = v2.answer5;
					jsonObj.answer6 = v2.answer6;
					jsonObj.qtanswer1 = v2.qtanswer1;
					jsonObj.qtanswer2 = v2.qtanswer2;
					jsonObj.qtanswer3 = v2.qtanswer3;
					jsonObj.qtanswer4 = v2.qtanswer4;
					jsonObj.qtanswer5 = v2.qtanswer5;
					jsonObj.qtanswer6 = v2.qtanswer6;
					
					local item = QuestionItem:new(jsonObj)
					QuestionsFeed:addItem(item)
					
					jsonObj = nil;
					item = nil;
      		    end
    		else
      			--[[print (k, v)--]]
    		end
  		end
	end

end

function QuestionsFeed:getItems()
	for i=1, #QuestionsFeed.items do
		local item = QuestionsFeed.items[i]
		if (item.completed == 0 ) then 
			QuestionsFeed:addNotCompletedQuestionItem(item)
		end
	end
			
	return QuestionsFeed.notCompletedQuestions;

end

function QuestionsFeed:getCurrentItem(n)
	return QuestionsFeed.notCompletedQuestions[n];
end

function QuestionsFeed:setCompleted()
	QuestionsFeed.items[1].completed = 1;
--	table.remove(QuestionsFeed.notCompletedQuestions, QuestionsFeed.notCompletedQuestions[1])

end