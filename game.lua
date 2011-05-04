module(..., package.seeall)

require("middleclass")
require("Lib_XmlParser")

-- Classes
require("Data_UrlLoader")
require("Rss_SyndicationFeed")
require("Rss_SyndicationItem")

function new()
	
	
	local g = display.newGroup()
	local question = display.newGroup()
	local answersGroup = display.newGroup()
	local remainingGroup = display.newGroup()
	local currentQuestionNumber = 1;
	
	score = require ("score")
	
	local remaining;
	
	local border = 5

	local scoreInfo = score.getInfo()

	score.init({
	x = 40,
	y = 5}
	)
	score.setScore(0)


	local bg = display.newImageRect("images/bg.png", 640, 959);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	g:insert(bg);
	--------------------------------------------------------------------------
	--								SCORE									--
	--------------------------------------------------------------------------

	local callback = function(rss)
		syndication = SyndicationFeed:new("NRK Feed")
		syndication:parseFeed(rss)
	
		local items = syndication:getItems()
		
		if (table.getn(items)>1) then
			-- we have a next question --
			
			---How many questions left?
			print (table.getn(items));

			getCurrentQuestion(currentQuestionNumber);
			
			local remainingItems = syndication:getItems()

			numberOfItems = table.getn(remainingItems)/2;


			remaining = display.newText (numberOfItems, 25,455, native.systemFont, 12)
			remaining:setTextColor(255,255,255)
			--> Line one of the question
			remainingGroup:insert(remaining)
			g:insert(remainingGroup)
			
		end
		--[[
		for i=1, #items do
		local item = items[i]
			print(i .. "-" .. item.question);
			local itemGroup = display.newGroup()
			local title = display.newText(item.question, 10, 10, "Helvetica", 16)
			itemGroup:insert(title)
			itemGroup.y = 10 + (40 * (i-1))
			g:insert(itemGroup) 
		end
		--]]
	end
	
	function getCurrentQuestion(n)
		
		--------------------------------------------------------------------------
		--								QUESTION								--
		--------------------------------------------------------------------------
		current = nil;
		-- Get Current Question
		current = syndication:getItems()
		current = syndication:getCurrentItem(n)
		
		print (current.question);
		
	--[[	TextCandy.AddCharset("questionFont", "questions_alphabet", "questions_alphabet.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 32) --]]
		
				TextCandy.AddCharset("questionFont", "questions_alphabet", "questions_alphabet.png", "A", 32)
				
		local question1 = TextCandy.CreateText({
			fontName 	= "questionFont",
			x		= 50,
			y		= 50,
			text	 	= "A",
			originX	 	= 25,
			originY	 	= 60,
			textFlow 	= "LEFT",
			wrapWidth	= 350,
			charSpacing 	= -12,
			lineSpacing	= 0,
			showOrigin 	= false
			})
		
	--[[	local question1 = display.newText (current.question, 25,60, native.systemFont, 12)
		question1:setTextColor(255,255,255)
		--> Line one of the question --]]
		
		question:insert(question1)
		answer1 = nil
		--------------------------------------------------------------------------
		--								ANSWERS									--
		--------------------------------------------------------------------------
		local answer1 = display.newImage ("images/button.png", 290, 39)
		answer1.x = 160
		answer1.y = 125
		answer1.id = 1;
		answer1.name = current.answer1;
		question:insert(answer1)
		answer1:addEventListener("touch", selectAnswer)

		local answer2 = display.newImage ("images/button.png", 290, 39)
		answer2.x = 160
		answer2.y = 175
		answer2.id = 2;
		answer2.name = current.answer2;
		question:insert(answer2)
		answer2:addEventListener("touch", selectAnswer)

		local answer3 = display.newImage ("images/button.png", 290, 39)
		answer3.x = 160
		answer3.y = 225
		answer3.id = 3;
		answer3.name = current.answer3;
		question:insert(answer3)
		answer3:addEventListener("touch", selectAnswer)
		
		local answer4 = display.newImage ("images/button.png", 290, 39)
		answer4.x = 160
		answer4.y = 275
		answer4.id = 4;
		answer4.name = current.answer4;
		question:insert(answer4)
		answer4:addEventListener("touch", selectAnswer)
		
		local answer5 = display.newImage ("images/button.png", 290, 39)
		answer5.x = 160
		answer5.y = 325
		answer5.id = 5;
		answer5.name = current.answer5;
		question:insert(answer5)
		answer5:addEventListener("touch", selectAnswer)
		
		local answer6 = display.newImage ("images/button.png", 290, 39)
		answer6.x = 160
		answer6.y = 375
		answer6.id = 6;
		answer6.name = current.answer6;
		question:insert(answer6)
		answer6:addEventListener("touch", selectAnswer)
		
		--> Places all three answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------

	--[[	local a1 = display.newText (current.answer1, 105, 112, native.systemFont, 14)
		a1:setTextColor (255,255,255) ]]
		
		
		local a1 = TextCandy.CreateText({
			fontName 	= "questionFont",
			x		= 105,
			y		= 112,
			text	 	= "AAAAAA",
			originX	 	= 0,
			originY	 	= 0,
			textFlow 	= "LEFT",
			wrapWidth	= 350,
			charSpacing 	= -12,
			lineSpacing	= 0,
			showOrigin 	= false
			})
		
		
		
		question:insert(a1)
		
		
		
		
		
		
		local a2 = display.newText (current.answer2, 105, 162, native.systemFont, 14)
		a2:setTextColor (255,255,255)
		question:insert(a2)

		local a3 = display.newText (current.answer3, 105, 212, native.systemFont, 14)
		a3:setTextColor (255,255,255)
		question:insert(a3)
		
		local a4 = display.newText (current.answer4, 105, 262, native.systemFont, 14)
		a4:setTextColor (255,255,255)
		question:insert(a4)
		
		local a5 = display.newText (current.answer5, 105, 312, native.systemFont, 14)
		a5:setTextColor (255,255,255)
		question:insert(a5)
		
		local a6 = display.newText (current.answer6, 105, 362, native.systemFont, 14)
		a6:setTextColor (255,255,255)
		question:insert(a6)
		--> Inserts text on each button, puts text in localGroup
		---------------------------------------------------------------------------
		
		g:insert(question);
		
	end
	
	function selectAnswer(event)
		if event.phase == "ended" then
		
		--- Change Score
		score.setScore (score.getScore()+107)
		
		print (event.target.name);
			
		--- show results
		showResults()
		--- mark question as completed
		syndication:setCompleted()
		--- mark which question was selected - 1 - 6


		end
	end
	
	function showResults()
		--> Places all three answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------
		local a1 = display.newText (current.qtanswer1, 280, 110, native.systemFont, 14)
		a1:setTextColor(255,255,255)
		answersGroup:insert(a1)
		
		local a2 = display.newText (current.qtanswer2, 280, 160, native.systemFont, 14)
		a2:setTextColor(255,255,255)
		answersGroup:insert(a2)

		local a3 = display.newText (current.qtanswer3, 280, 210, native.systemFont, 14)
		a3:setTextColor(255,255,255)
		answersGroup:insert(a3)
		
		local a4 = display.newText (current.qtanswer4, 280, 260, native.systemFont, 14)
		a4:setTextColor(255,255,255)
		answersGroup:insert(a4)
		
		local a5 = display.newText (current.qtanswer5, 280, 310, native.systemFont, 14)
		a5:setTextColor(255,255,255)
		answersGroup:insert(a5)
		
		local a6 = display.newText (current.qtanswer6, 280, 360, native.systemFont, 14)
		a6:setTextColor(255,255,255)
		answersGroup:insert(a6)
		
		g:insert(answersGroup);
		
	end
	
	
	function getNextQuestion(event)
		if event.phase == "ended" then
			print('next')
			print('current is' .. current.question)
			
			g:remove(remaining)
			
			numberOfItems = numberOfItems - 1;
			
			remaining = display.newText (numberOfItems, 25,455, native.systemFont, 12)
			remaining:setTextColor(255,255,255)
			g:insert(remaining);
			
			--- remove current question
			cleanGroup( question )
			question = nil
			question = display.newGroup();
			--- insert new question
			getCurrentQuestion(currentQuestionNumber)
			currentQuestionNumber = currentQuestionNumber+1;
			
		end
	end
	
	local next = display.newImage("next.png")
	next.x = 260
	next.y = 35
	g:insert(next)
	next:addEventListener("touch", getNextQuestion)

	
	UrlLoader:new("http://localhost/intuition_rest/public/question/format/json", callback)
	
	return g
end