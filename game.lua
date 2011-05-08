module(..., package.seeall)

require("middleclass")
require("Lib_XmlParser")

-- Classes
require("Data_UrlLoader")
require("QuestionsFeed")
require("QuestionItem")
require("Score")

function new()
	local ui = require ( "ui" )
	local charts = require("charts")
	
	local g = display.newGroup()
	local question = display.newGroup()
	local answersGroup = display.newGroup()
	local questionMarkGroup = display.newGroup()
	local scoreGroup = display.newGroup()
	local remainingGroup = display.newGroup()
	local currentQuestionNumber = 1;
	local numberOfItems = 1;
	
	local popUpAnwserGroup = display.newGroup()
--	popUpAnwserGroup.x = display.contentWidth*-1 -- start with the High Score screen out of site
	popUpAnwserGroup.y = display.contentHeight*1 -- start with the High Score screen out of site

	popUpAnwserGroup.alpha = 0 -- and start with it transparent
	
	local bgAnswer = display.newImageRect("images/answerbg.png", 320, 488);
	bgAnswer:setReferencePoint(display.CenterReferencePoint);
	bgAnswer.x = _W/2; bgAnswer.y = _H/2;
	popUpAnwserGroup:insert(bgAnswer);


	function closePopupAndGetNewQuestion()
	--	popUpAnwserGroup.alpha = 0;

		transition.to(popUpAnwserGroup, {time=300, y = display.contentHeight*1, alpha=1 , onComplete = popCloseCallBack})
	end
	
	function popCloseCallBack()
		 	popUpAnwserGroup.alpha = 0;
				
	end
	
	
	local remaining;
	
	local border = 5

	removeLastView = {}
	lastView = {}

	
	local bg = display.newImageRect("images/bg_questions.png", 364, 488);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	g:insert(bg);
	
	local homeIcon = display.newImage ("images/home_icon.png", 38, 32)
	homeIcon.x = 30
	homeIcon.y = 20
	g:insert(homeIcon)
	
	
	function goToFrontScreen(e)
		
		if(e.phase == "ended") then
			director:changeScene('menu', "moveFromRight");
			media.playEventSound("button_front.mp3")
		end
		
	end
	
	homeIcon:addEventListener("touch", goToFrontScreen)
	
	--------------------------------------------------------------------------
	--								SCORE									--
	--------------------------------------------------------------------------
	
	-- SET SCORE. Have to define where it will be located
	currentScore = Score:new()
	currentScore:setScore(0)
	
	local scoreDisplay = display.newText (currentScore:getScore(), 270, 10, "Helvetica", 14)
	scoreDisplay:setTextColor (255,255,255)
	scoreGroup:insert(scoreDisplay)
	
	g:insert(scoreGroup);

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
		
		local question1 = autoWrappedText(current.question, nil, 15, {255, 255, 255}, 260)
		
		question1.y = 75;
		question1.x = 20;
		
		question:insert(question1)
		
		--------------------------------------------------------------------------
		--								ANSWERS									--
		--------------------------------------------------------------------------

		local answer1 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 155,
		}
		answer1.id = 1;
		answer1.name = current.answer1;
		question:insert(answer1)
		answer1:addEventListener("touch", selectAnswer)
		
		local answer2 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 205,
		}
		answer2.id = 2;
		answer2.name = current.answer2;
		question:insert(answer2)
		answer2:addEventListener("touch", selectAnswer)
		
		local answer3 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 255,
		}
		answer3.id = 3;
		answer3.name = current.answer3;
		question:insert(answer3)
		answer3:addEventListener("touch", selectAnswer)
		
		local answer4 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 305,
		}
		answer4.id = 4;
		answer4.name = current.answer4;
		question:insert(answer4)
		answer4:addEventListener("touch", selectAnswer)
		
		local answer5 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 355,
		}
		answer5.id = 5;
		answer5.name = current.answer5;
		question:insert(answer5)
		answer5:addEventListener("touch", selectAnswer)
		
		local answer6 = toggle.newToggle{
			default = "images/button.png",
			on = "images/button_over.png",
			x = 160,
			y = 405,
		}
		answer6.id = 6;
		answer6.name = current.answer6;
		question:insert(answer6)
		answer6:addEventListener("touch", selectAnswer)
		

		
		--> Places all six answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------

		local a1 = display.newText (current.answer1, 105, 142, "Helvetica", 14)
		a1:setTextColor (255,255,255) 
		question:insert(a1)

		local a2 = display.newText (current.answer2, 105, 192, "Helvetica", 14)
		a2:setTextColor (255,255,255)
		question:insert(a2)

		local a3 = display.newText (current.answer3, 105, 242, "Helvetica", 14)
		a3:setTextColor (255,255,255)
		question:insert(a3)
		
		local a4 = display.newText (current.answer4, 105, 292, "Helvetica", 14)
		a4:setTextColor (255,255,255)
		question:insert(a4)
		
		local a5 = display.newText (current.answer5, 105, 342, "Helvetica", 14)
		a5:setTextColor (255,255,255)
		question:insert(a5)
		
		local a6 = display.newText (current.answer6, 105, 392, "Helvetica", 14)
		a6:setTextColor (255,255,255)
		question:insert(a6)
		
		--> Inserts text on each button, puts text in localGroup
		---------------------------------------------------------------------------
		
		
		local a1 = display.newText ("A", 54, 143, "Helvetica", 14)
		a1:setTextColor(255,255,255)
		questionMarkGroup:insert(a1)
		
		local a2 = display.newText ("B", 54, 193, "Helvetica", 14)
		a2:setTextColor(255,255,255)
		questionMarkGroup:insert(a2)

		local a3 = display.newText ("C", 54, 243, "Helvetica", 14)
		a3:setTextColor(255,255,255)
		questionMarkGroup:insert(a3)
		
		local a4 = display.newText ("D", 54, 293, "Helvetica", 14)
		a4:setTextColor(255,255,255)
		questionMarkGroup:insert(a4)
		
		local a5 = display.newText ("E", 54, 343, "Helvetica", 14)
		a5:setTextColor(255,255,255)
		questionMarkGroup:insert(a5)
		
		local a6 = display.newText ("F", 54, 393, "Helvetica", 14)
		a6:setTextColor(255,255,255)
		questionMarkGroup:insert(a6)
		
		
		g:insert(question);
		
		g:insert(questionMarkGroup);
		
		
	end
	
	function selectAnswer(event)
		if event.phase == "ended" then
		
		--- Change Score
		currentScore:setScore (currentScore:getScore()+107)
		cleanGroup(scoreGroup)
		scoreDisplay = nil
--		scoreGroup = nil
		scoreGroup = display.newGroup()
        scoreDisplay = display.newText (currentScore:getScore(), 270, 10, "Helvetica", 16)
		scoreDisplay:setTextColor (255,255,255)
		scoreGroup:insert(scoreDisplay)
		g:insert(scoreGroup)
		
		print (event.target.name);
			
		--- show results
		showResults()
		--- mark question as completed
		questionsFeed:setCompleted()
		--- mark which question was selected - 1 - 6


		end
	end
	
	function showResults()
		popAnwserScreen();
	end
	
	
	function getNextQuestion(event)
		if event.phase == "ended" then
			
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
			currentQuestionNumber = currentQuestionNumber+1;
			
			setCurrentQuestion(currentQuestionNumber)
			closePopupAndGetNewQuestion();
			
	
		end
	end
	
	function popAnwserScreen()
		cleanGroup(popUpAnwserGroup)
		
		popUpAnwserGroup = display.newGroup();
		popUpAnwserGroup.y = display.contentHeight*1 -- start with the High Score screen out of site

		popUpAnwserGroup.alpha = 0 --
		
		
		local bgAnswer = display.newImageRect("images/answerbg.png", 320, 488);
		bgAnswer:setReferencePoint(display.CenterReferencePoint);
		bgAnswer.x = _W/2; bgAnswer.y = _H/2;
		popUpAnwserGroup:insert(bgAnswer);
		
		
		local resultsLabel = autoWrappedText("Results", nil, 34, {0, 0, 0}, 270)
		resultsLabel.y = 15;
		resultsLabel.x = 20;
		popUpAnwserGroup:insert(resultsLabel)
		
		
		local question1 = autoWrappedText(current.question, nil, 14, {108, 108, 108}, 270)
		question1.y = 65;
		question1.x = 20;
		popUpAnwserGroup:insert(question1)
		
		local pointsObtained = autoWrappedText("My Score:" .. currentScore:getScore(), nil, 14, {0, 0, 0}, 270)
		pointsObtained.y = 27;
		pointsObtained.x = 210;
		popUpAnwserGroup:insert(pointsObtained)
		

		local next = display.newImage("images/next_question.png")
		next.x = 165
		next.y = 445
		popUpAnwserGroup:insert(next)
		next:addEventListener("touch", getNextQuestion)
		
		currentResultsPie = nil;

		local currentResultsPie = charts.newChart
		{
			type = "pie",
			title = "",
			legend = current.answer1 .. "|" .. current.answer2 .. "|" .. current.answer3 .. "|" .. current.answer4 .. "|" .. current.answer5 .. "|" .. current.answer6,
			legendPosition = "t",
			width = 320,
			height = 350,
			labels = current.qtanswer1 .. "|".. current.qtanswer2 .. "|" .. current.qtanswer3 .. "|" .. current.qtanswer4 .. "|" .. current.qtanswer5 .. "|" .. current.qtanswer6,
			data = "t:".. current.qtanswer1 .. ",".. current.qtanswer2 .. "," .. current.qtanswer3 .. "," .. current.qtanswer4 .. "," .. current.qtanswer5 .. "," .. current.qtanswer6,
			mode = "2d",
			dataColours = "522369|208405|334a06|6d0a75|cf356f|e03737",
			scale = {0, 100},
			margins = {20, 0, 0, 20},
			transparency = 0,
			x = -10,
			y = 90
		}

		local chartImage = display.newImage( currentResultsPie.filename, system.DocumentsDirectory, currentResultsPie.x or 0, currentResultsPie.y or 0 )
		popUpAnwserGroup:insert(chartImage)
		
		transition.to(popUpAnwserGroup, {time=300, y = 0, alpha=1 })
		
	end
	


	--[[Get List of Questions from Server ]]
	UrlLoader:new("http://localhost/intuition.json", callback)
	
	return g
end