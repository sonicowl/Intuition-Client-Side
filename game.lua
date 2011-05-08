module(..., package.seeall)

require("middleclass")
require("Lib_XmlParser")

-- Classes
require("Data_UrlLoader")
require("QuestionsFeed")
require("QuestionItem")

function new()
	
	
	local g = display.newGroup()
	local question = display.newGroup()
	local answersGroup = display.newGroup()
	local questionMarkGroup = display.newGroup()
	local remainingGroup = display.newGroup()
	local currentQuestionNumber = 1;
	local numberOfItems = 1;
	score = require ("score")
	
	local remaining;
	
	local border = 5

	local scoreInfo = score.getInfo()

	local bg = display.newImageRect("images/bg_questions.png", 364, 488);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	g:insert(bg);
	
	local homeIcon = display.newImage ("images/home_icon.png", 38, 32)
	homeIcon.x = 30
	homeIcon.y = 20
	g:insert(homeIcon)
	
	
	--------------------------------------------------------------------------
	--								SCORE									--
	--------------------------------------------------------------------------
	
	-- SET SCORE. Have to define where it will be located

		score.init({
		x = 300,
		y = 20}
		)
		score.setScore(0)



	local callback = function(rss)
		questionsFeed = QuestionsFeed:new("Questions")
		questionsFeed:parseFeed(rss)
	
		local items = questionsFeed:getItems()
		print('remainning' .. table.getn(items))
		if (table.getn(items)>1) then
			-- we have a next question --
			
			---How many questions left?

			setCurrentQuestion(currentQuestionNumber);
			print('number of items' .. table.getn(items))
			

			remaining = display.newText (numberOfItems .. ' of 30', 134,13, native.systemFont, 12)
			remaining:setTextColor(255,255,255)
			--> Line one of the question
			remainingGroup:insert(remaining)
			g:insert(remainingGroup)
			
		end

	end
	
	function setCurrentQuestion(n)
		
		--------------------------------------------------------------------------
		--								QUESTION								--
		--------------------------------------------------------------------------
		current = nil;
		-- Get Current Question
		current = questionsFeed:getCurrentItem(n)
		print (current.question);
		
		local question1 = autoWrappedText(current.question, nil, 14, {255, 255, 255}, 270)
		
		question1.y = 55;
		question1.x = 20;
		
		question:insert(question1)
		
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
		
		--> Places all six answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------

		local a1 = display.newText (current.answer1, 105, 112, "Helvetica", 14)
		a1:setTextColor (255,255,255) 
		question:insert(a1)

		local a2 = display.newText (current.answer2, 105, 162, "Helvetica", 14)
		a2:setTextColor (255,255,255)
		question:insert(a2)

		local a3 = display.newText (current.answer3, 105, 212, "Helvetica", 14)
		a3:setTextColor (255,255,255)
		question:insert(a3)
		
		local a4 = display.newText (current.answer4, 105, 262, "Helvetica", 14)
		a4:setTextColor (255,255,255)
		question:insert(a4)
		
		local a5 = display.newText (current.answer5, 105, 312, "Helvetica", 14)
		a5:setTextColor (255,255,255)
		question:insert(a5)
		
		local a6 = display.newText (current.answer6, 105, 362, "Helvetica", 14)
		a6:setTextColor (255,255,255)
		question:insert(a6)
		
		--> Inserts text on each button, puts text in localGroup
		---------------------------------------------------------------------------
		
		
		local a1 = display.newText ("?", 54, 113, "Helvetica", 14)
		a1:setTextColor(255,255,255)
		questionMarkGroup:insert(a1)
		
		local a2 = display.newText ("?", 54, 163, "Helvetica", 14)
		a2:setTextColor(255,255,255)
		questionMarkGroup:insert(a2)

		local a3 = display.newText ("?", 54, 213, "Helvetica", 14)
		a3:setTextColor(255,255,255)
		questionMarkGroup:insert(a3)
		
		local a4 = display.newText ("?", 54, 263, "Helvetica", 14)
		a4:setTextColor(255,255,255)
		questionMarkGroup:insert(a4)
		
		local a5 = display.newText ("?", 54, 313, "Helvetica", 14)
		a5:setTextColor(255,255,255)
		questionMarkGroup:insert(a5)
		
		local a6 = display.newText ("?", 54, 363, "Helvetica", 14)
		a6:setTextColor(255,255,255)
		questionMarkGroup:insert(a6)
		
		
		g:insert(question);
		
		g:insert(questionMarkGroup);
		
		
	end
	
	function selectAnswer(event)
		if event.phase == "ended" then
		
		--- Change Score
		score.setScore (score.getScore()+107)
		
		print (event.target.name);
			
		--- show results
		showResults()
		--- mark question as completed
		questionsFeed:setCompleted()
		--- mark which question was selected - 1 - 6


		end
	end
	
	function showResults()
		
		cleanGroup( questionMarkGroup )
		questionMarkGroup = nil
		questionMarkGroup = display.newGroup();
		--> Places all three answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------
		local a1 = display.newText (current.qtanswer1, 54, 113, "Helvetica", 14)
		a1:setTextColor(255,255,255)
		answersGroup:insert(a1)
		
		local a2 = display.newText (current.qtanswer2, 54, 163, "Helvetica", 14)
		a2:setTextColor(255,255,255)
		answersGroup:insert(a2)

		local a3 = display.newText (current.qtanswer3, 54, 213, "Helvetica", 14)
		a3:setTextColor(255,255,255)
		answersGroup:insert(a3)
		
		local a4 = display.newText (current.qtanswer4, 54, 263, "Helvetica", 14)
		a4:setTextColor(255,255,255)
		answersGroup:insert(a4)
		
		local a5 = display.newText (current.qtanswer5, 54, 313, "Helvetica", 14)
		a5:setTextColor(255,255,255)
		answersGroup:insert(a5)
		
		local a6 = display.newText (current.qtanswer6, 54, 363, "Helvetica", 14)
		a6:setTextColor(255,255,255)
		answersGroup:insert(a6)
		
		g:insert(answersGroup);
		
	end
	
	
	function getNextQuestion(event)
		if event.phase == "ended" then
			print('next')
			print('current is' .. current.question)
			
			g:remove(remaining)
			
			numberOfItems = numberOfItems + 1;
			
			remaining = display.newText (numberOfItems .. ' of 30', 134,13, native.systemFont, 12)
			remaining:setTextColor(255,255,255)
			g:insert(remaining);
			
			--- remove current question
			cleanGroup( question )
			question = nil
			question = display.newGroup();
			--- insert new question
			setCurrentQuestion(currentQuestionNumber)
			currentQuestionNumber = currentQuestionNumber+1;
			
		end
	end
	
	local next = display.newImage("images/next_question.png")
	next.x = 220
	next.y = 435
	g:insert(next)
	next:addEventListener("touch", getNextQuestion)

	--[[Get List of Questions from Server ]]
	UrlLoader:new("http://localhost/intuition.json", callback)
	
	return g
end