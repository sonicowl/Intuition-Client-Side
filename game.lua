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

	selectedAwswer = nil;
	currentScore = Score:new();

	function closePopupAndGetNewQuestion()
	--	popUpAnwserGroup.alpha = 0;

		transition.to(popUpAnwserGroup, {time=300, y = display.contentHeight*1, alpha=1 , onComplete = popCloseCallBack})
	end
	
	function popCloseCallBack()
		 	popUpAnwserGroup.alpha = 0;
				
	end
	
	
	local remaining;
	local scoreDisplay;
	
	local border = 5

	removeLastView = {}
	lastView = {}

	
	local bg = display.newImageRect("images/bg_game.png", 768, 1024);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	g:insert(bg);
	
	local homeIcon = display.newImage ("images/home_icon.png", 50, 50)
	homeIcon.x = 30
	homeIcon.y = 30
	g:insert(homeIcon)
	
	
	function goToFrontScreen(e)
		if(e.phase == "ended") then
			director:changeScene('menu', "moveFromLeft");
			media.playEventSound("button_front.mp3")
		end
	end
	
	homeIcon:addEventListener("touch", goToFrontScreen)
	
	--------------------------------------------------------------------------
	--								SCORE									--
	--------------------------------------------------------------------------
	
	-- SET SCORE. Have to define where it will be located

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

			numberOfQuestionsTxt = display.newText ('Questions', display.contentWidth/2-200,display.contentHeight - 160, native.systemFont, 32)
			numberOfQuestionsTxt:setTextColor(255,255,255)
			--> Line one of the question
			remainingGroup:insert(numberOfQuestionsTxt)
			g:insert(numberOfQuestionsTxt)


			remaining = display.newText (numberOfItems .. ' of 30', display.contentWidth/2 - 10,display.contentHeight - 160, native.systemFont, 32)
			remaining:setTextColor(255,255,0)
			--> Line one of the question
			remainingGroup:insert(remaining)
			g:insert(remainingGroup)
			
			
			--- MY SCORE ----
			
			myScoreTxt = display.newText ('My Score', display.contentWidth/2-200,display.contentHeight - 110, native.systemFont, 32)
			myScoreTxt:setTextColor(255,255,255)
			--> Line one of the question
			remainingGroup:insert(myScoreTxt)
			g:insert(myScoreTxt)
			
			
		--	myScore = display.newText (numberOfItems .. ' of 30', display.contentWidth/2 - 10,display.contentHeight - 160, native.systemFont, 32)
		--	myScore:setTextColor(255,255,0)
			--> Line one of the question
		--	remainingGroup:insert(myScore)
		--	g:insert(myScore)
			
			
			--currentScore:setScore(0)
			print('score is =' ..currentScore:getScore());
			scoreDisplay = display.newText (currentScore:getScore(),display.contentWidth/2 - 10,display.contentHeight - 110, "Helvetica", 32)
			scoreDisplay:setTextColor (255,255,0)
			scoreGroup:insert(scoreDisplay)
			g:insert(scoreGroup);
			
			
		end

	end
	
	function setCurrentQuestion(n)
		
		--------------------------------------------------------------------------
		--								IF QUESTION = 30? Game Over				--
		--------------------------------------------------------------------------
		if n > 1 then
			director:changeScene('gameover', "fade");
		end
		
		--------------------------------------------------------------------------
		--								QUESTION								--
		--------------------------------------------------------------------------
		current = nil;
		-- Get Current Question
		current = questionsFeed:getCurrentItem(n)
		
		
		local question1 = autoWrappedText(current.question, nil, 30, {255, 255, 255}, 576)
		print('question1.height' ..question1.height);
		if (question1.height >36) then
			question1.y = 190;
		else
			question1.y = 210;
		end
		
		question1:setReferencePoint(display.CenterReferencePoint);
		question1.x = display.contentWidth * 0.5;
		
		question:insert(question1)
		
		--------------------------------------------------------------------------
		--								ANSWERS									--
		--------------------------------------------------------------------------

		local answer1 = toggle.newToggle{
			default = "images/button1.png",
			on = "images/button_over.png",
			x = 380,
			y = 345,
		}
		answer1.id = 1;
		answer1.name = current.answer1;
		question:insert(answer1)
		answer1:addEventListener("touch", selectAnswer)
		
		local answer2 = toggle.newToggle{
			default = "images/button2.png",
			on = "images/button_over.png",
			x = 380,
			y = 430,
		}
		answer2.id = 2;
		answer2.name = current.answer2;
		question:insert(answer2)
		answer2:addEventListener("touch", selectAnswer)
		
		local answer3 = toggle.newToggle{
			default = "images/button3.png",
			on = "images/button_over.png",
			x = 380,
			y = 515,
		}
		answer3.id = 3;
		answer3.name = current.answer3;
		question:insert(answer3)
		answer3:addEventListener("touch", selectAnswer)
		
		local answer4 = toggle.newToggle{
			default = "images/button4.png",
			on = "images/button_over.png",
			x = 380,
			y = 605,
		}
		answer4.id = 4;
		answer4.name = current.answer4;
		question:insert(answer4)
		answer4:addEventListener("touch", selectAnswer)
		
		local answer5 = toggle.newToggle{
			default = "images/button5.png",
			on = "images/button_over.png",
			x = 380,
			y = 690,
		}
		answer5.id = 5;
		answer5.name = current.answer5;
		question:insert(answer5)
		answer5:addEventListener("touch", selectAnswer)
		
		local answer6 = toggle.newToggle{
			default = "images/button6.png",
			on = "images/button_over.png",
			x = 380,
			y = 775,
		}
		answer6.id = 6;
		answer6.name = current.answer6;
		question:insert(answer6)
		answer6:addEventListener("touch", selectAnswer)
		

		
		--> Places all six answer buttons and inserts them into localGroup
		---------------------------------------------------------------------------

		local a1 = display.newText (current.answer1, 0, 0, "Helvetica", 30)
		a1:setReferencePoint(display.CenterReferencePoint);
		a1.x = display.contentWidth * 0.5;
		a1.y = 345;
		a1:setTextColor (255,255,255) 
		question:insert(a1)

		local a2 = display.newText (current.answer2, 0, 0, "Helvetica", 30)
		a2:setReferencePoint(display.CenterReferencePoint);
		a2.x = display.contentWidth * 0.5;
		a2.y = 430;
		a2:setTextColor (255,255,255)
		question:insert(a2)

		local a3 = display.newText (current.answer3, 0, 0, "Helvetica", 30)
		a3:setReferencePoint(display.CenterReferencePoint);
		a3.x = display.contentWidth * 0.5;
		a3.y = 515;
		a3:setTextColor (255,255,255)
		question:insert(a3)
		
		local a4 = display.newText (current.answer4, 0, 0, "Helvetica", 30)
		a4:setReferencePoint(display.CenterReferencePoint);
		a4.x = display.contentWidth * 0.5;
		a4.y = 605;
		a4:setTextColor (255,255,255)
		question:insert(a4)
		
		local a5 = display.newText (current.answer5, 0, 0, "Helvetica", 30)
		a5:setReferencePoint(display.CenterReferencePoint);
		a5.x = display.contentWidth * 0.5;
		a5.y = 690;
		a5:setTextColor (255,255,255)
		question:insert(a5)
		
		local a6 = display.newText (current.answer6, 0, 0, "Helvetica", 30)
		a6:setReferencePoint(display.CenterReferencePoint);
		a6.x = display.contentWidth * 0.5;
		a6.y = 775;
		a6:setTextColor (255,255,255)
		question:insert(a6)
		
		--> Inserts text on each button, puts text in localGroup
		---------------------------------------------------------------------------

		g:insert(question);
		
		g:insert(questionMarkGroup);
		
		
	end
	
	function selectAnswer(event)
		if event.phase == "ended" then
		
		--- Change Score
		cleanGroup(scoreGroup)
		scoreDisplay = nil
--		scoreGroup = nil
		scoreGroup = display.newGroup()
		g:insert(scoreGroup)
		selectedAwswer = event.target.name;
		selectedAwswerId = event.target.id;
		
		print (event.target.name);
			
		--- show results
		showResults(event.target.name)
		--- mark question as completed
		questionsFeed:setCompleted()
		--- mark which question was selected - 1 - 6


		end
	end
	
	function showResults(resposta)
		popAnwserScreen(resposta);
	end
	
	
	function getNextQuestion(event)
		if event.phase == "ended" then
			native.cancelWebPopup();
			g:remove(remaining)
			g:remove(scoreGroup)
			scoreGroup = display.newGroup()
			
			numberOfItems = numberOfItems + 1;
			
			remaining = display.newText (numberOfItems .. ' of 30', display.contentWidth/2 - 10,display.contentHeight - 160, native.systemFont, 32)
			remaining:setTextColor(255,255,0)
			--> Line one of the question
			g:insert(remaining)
			
			scoreDisplay = display.newText (currentScore:getScore(),display.contentWidth/2 - 10,display.contentHeight - 110, "Helvetica", 32)
			scoreDisplay:setTextColor (255,255,0)
			scoreGroup:insert(scoreDisplay);
			g:insert(scoreGroup);
			
			
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
	
	function popAnwserScreen(resposta)
		cleanGroup(popUpAnwserGroup)
		
		popUpAnwserGroup = display.newGroup();
		popUpAnwserGroup.y = display.contentHeight*1 -- start with the High Score screen out of site

		popUpAnwserGroup.alpha = 0 --
		
		local bgAnswer = display.newImageRect("images/bg_results.png", 768, 1024);
		bgAnswer:setReferencePoint(display.CenterReferencePoint);
		bgAnswer.x = _W/2; bgAnswer.y = _H/2;
		popUpAnwserGroup:insert(bgAnswer);

		local next = display.newImage("images/next_question.png", 245, 81)
		next.x = 405
		next.y = display.contentHeight - 60;
		popUpAnwserGroup:insert(next)
		
	--	local backBtn = display.newImage("images/back_to_home.png", 245, 81)
	---	backBtn.x = 225
	--	backBtn.y = display.contentHeight - 60;
	--	popUpAnwserGroup:insert(backBtn)
		
		local question1 = autoWrappedText(current.question, nil, 30, {255, 255, 255}, 576)
		
		if (question1.height >36) then
			question1.y = 185;
		else
			question1.y = 205;
		end
		question1:setReferencePoint(display.CenterReferencePoint);
		question1.x = display.contentWidth * 0.5;
		
		popUpAnwserGroup:insert(question1)
		
		local answer = autoWrappedText(selectedAwswer, nil, 35, {255, 255, 0}, 576)
		
		answer.y = 296;
		answer:setReferencePoint(display.CenterReferencePoint);
		answer.x = display.contentWidth * 0.5;
		
		popUpAnwserGroup:insert(answer)
		
		local selectedId = 'current.qtanswer' .. selectedAwswerId;
		
		if selectedAwswerId == 1 then selectedId = current.qtanswer1 end
		if selectedAwswerId == 2 then selectedId = current.qtanswer2 end
		if selectedAwswerId == 3 then selectedId = current.qtanswer3 end
		if selectedAwswerId == 4 then selectedId = current.qtanswer4 end
		if selectedAwswerId == 5 then selectedId = current.qtanswer5 end
		if selectedAwswerId == 6 then selectedId = current.qtanswer6 end
		
		local peopleWhoAgreeNumber = autoWrappedText(selectedId, nil, 30, {255, 255, 0}, 576)
		peopleWhoAgreeNumber.y = 556;
		peopleWhoAgreeNumber.x = (display.contentWidth* 0.5)+ 300*0.5;
		popUpAnwserGroup:insert(peopleWhoAgreeNumber)
		
		local progressNumber = autoWrappedText(currentQuestionNumber .. ' of 30', nil, 23, {255, 255, 0}, 576)
		progressNumber.y = 368;
		progressNumber.x = (display.contentWidth* 0.5)+ 330*0.5;
		popUpAnwserGroup:insert(progressNumber)
		
		native.cancelWebPopup()
		
		local options = { 
		  baseUrl = system.ResourceDirectory, 
		  hasBackground = false, 
		  urlRequest = listener 
		}
		local url = "test.html?param1=" ..current.qtanswer1.."&param2="..current.qtanswer2 .."&param3=" ..current.qtanswer3.."&param4=" ..current.qtanswer4.."&param5=" ..current.qtanswer5.."&param6=" ..current.qtanswer6 .."";
--		native.showWebPopup( "test.html", 50, 250, 320, 316, options )	
		print ('url=' ..url);
		native.showWebPopup(50, 353, 330, 340, url, options )		
		
		
	--	print ('total views = '.. tostring(current.totalViews));
		
		local peopleWhoViewedTheQuestion = autoWrappedText(current.totalViews, nil, 30, {255, 255, 0}, 576)
		peopleWhoViewedTheQuestion.y = 480;
		peopleWhoViewedTheQuestion.x = (display.contentWidth* 0.5)+ 300*0.5;
		
		popUpAnwserGroup:insert(peopleWhoViewedTheQuestion)
		
		
		square1 = display.newRect(120, 710, 20, 20)
		square1:setFillColor(0, 87, 168)
		popUpAnwserGroup:insert(square1)
		
		square2 = display.newRect(120, 737, 20, 20)
		square2:setFillColor(128, 165, 0)
		popUpAnwserGroup:insert(square2)
		
		square3 = display.newRect(120, 767, 20, 20)
		square3:setFillColor(191, 60, 6)
		popUpAnwserGroup:insert(square3)
		
		square4 = display.newRect(120, 797, 20, 20)
		square4:setFillColor(179, 135, 0)
		popUpAnwserGroup:insert(square4)
		
		square5 = display.newRect(120, 827, 20, 20)
		square5:setFillColor(105, 40, 169)
		popUpAnwserGroup:insert(square5)
		
		square6 = display.newRect(120, 857, 20, 20)
		square6:setFillColor(194, 2, 8)
		popUpAnwserGroup:insert(square6)
		
		next:addEventListener("touch", getNextQuestion)

		
		--backBtn:addEventListener("touch", goToFrontScreen)
		
		
		maxlabel = 705;
		labelinc = 30;
		startvotes = 180;
		startscore = 250;
		startlabel = 330;
		label1 = maxlabel;
		label2 = maxlabel;
		label3 = maxlabel;
		label4 = maxlabel;
		label5 = maxlabel;
		label6 = maxlabel;
	
		if (tonumber(current.qtanswer1) < tonumber(current.qtanswer2)) then label1 = label1 + labelinc; end
		if (tonumber(current.qtanswer1) < tonumber(current.qtanswer3)) then label1 = label1 + labelinc; end
		if (tonumber(current.qtanswer1) < tonumber(current.qtanswer4)) then label1 = label1 + labelinc; end
		if (tonumber(current.qtanswer1) < tonumber(current.qtanswer5)) then label1 = label1 + labelinc; end
		if (tonumber(current.qtanswer1) < tonumber(current.qtanswer6)) then label1 = label1 + labelinc; end
		
		if (tonumber(current.qtanswer2) < tonumber(current.qtanswer1)) then label2 = label2 + labelinc; end
		if (tonumber(current.qtanswer2) < tonumber(current.qtanswer3)) then label2 = label2 + labelinc; end
		if (tonumber(current.qtanswer2) < tonumber(current.qtanswer4)) then label2 = label2 + labelinc; end
		if (tonumber(current.qtanswer2) < tonumber(current.qtanswer5)) then label2 = label2 + labelinc; end
		if (tonumber(current.qtanswer2) < tonumber(current.qtanswer6)) then label2 = label2 + labelinc; end
		
		if (tonumber(current.qtanswer3) < tonumber(current.qtanswer1)) then label3 = label3 + labelinc; end
		if (tonumber(current.qtanswer3) < tonumber(current.qtanswer2)) then label3 = label3 + labelinc; end
		if (tonumber(current.qtanswer3) < tonumber(current.qtanswer4)) then label3 = label3 + labelinc; end
		if (tonumber(current.qtanswer3) < tonumber(current.qtanswer5)) then label3 = label3 + labelinc; end
		if (tonumber(current.qtanswer3) < tonumber(current.qtanswer6)) then label3 = label3 + labelinc; end
		
		if (tonumber(current.qtanswer4) < tonumber(current.qtanswer1)) then label4 = label4 + labelinc; end
		if (tonumber(current.qtanswer4) < tonumber(current.qtanswer2)) then label4 = label4 + labelinc; end
		if (tonumber(current.qtanswer4) < tonumber(current.qtanswer3)) then label4 = label4 + labelinc; end
		if (tonumber(current.qtanswer4) < tonumber(current.qtanswer5)) then label4 = label4 + labelinc; end
		if (tonumber(current.qtanswer4) < tonumber(current.qtanswer6)) then label4 = label4 + labelinc; end
		
		if (tonumber(current.qtanswer5) < tonumber(current.qtanswer1)) then label5 = label5 + labelinc; end
		if (tonumber(current.qtanswer5) < tonumber(current.qtanswer2)) then label5 = label5 + labelinc; end
		if (tonumber(current.qtanswer5) < tonumber(current.qtanswer3)) then label5 = label5 + labelinc; end
		if (tonumber(current.qtanswer5) < tonumber(current.qtanswer4)) then label5 = label5 + labelinc; end
		if (tonumber(current.qtanswer5) < tonumber(current.qtanswer6)) then label5 = label5 + labelinc; end
		 
		if (tonumber(current.qtanswer6) < tonumber(current.qtanswer1)) then label6 = label6 + labelinc; end
		if (tonumber(current.qtanswer6) < tonumber(current.qtanswer2)) then label6 = label6 + labelinc; end
		if (tonumber(current.qtanswer6) < tonumber(current.qtanswer3)) then label6 = label6 + labelinc; end
		if (tonumber(current.qtanswer6) < tonumber(current.qtanswer4)) then label6 = label6 + labelinc; end
		if (tonumber(current.qtanswer6) < tonumber(current.qtanswer5)) then label6 = label6 + labelinc; end
		
		score1=0;
		if (label1 == maxlabel) then score1=100; end
		if (label1 == maxlabel + labelinc) then score1=50; end
		if (label1 == maxlabel + (labelinc * 2)) then score1=10; end
		if (label1 == maxlabel + (labelinc * 3)) then score1=5; end
		if (label1 == maxlabel + (labelinc * 4)) then score1=1; end
		if (label1 == maxlabel + (labelinc * 5)) then score1=0; end
		
		score2=0;
		if (label2 == maxlabel) then score2=100; end
		if (label2 == maxlabel + labelinc) then score2=50; end
		if (label2 == maxlabel + (labelinc * 2)) then score2=10; end
		if (label2 == maxlabel + (labelinc * 3)) then score2=5; end
		if (label2 == maxlabel + (labelinc * 4)) then score2=1; end
		if (label2 == maxlabel + (labelinc * 5)) then score2=0; end
		
		score3=0;
		if (label3 == maxlabel) then score3=100; end
		if (label3 == maxlabel + labelinc) then score3=50; end
		if (label3 == maxlabel + (labelinc * 2)) then score3=10; end
		if (label3 == maxlabel + (labelinc * 3)) then score3=5; end
		if (label3 == maxlabel + (labelinc * 4)) then score3=1; end
		if (label3 == maxlabel + (labelinc * 5)) then score3=0; end
		
		score4=0;
		if (label4 == maxlabel) then score4=100; end
		if (label4 == maxlabel + labelinc) then score4=50; end
		if (label4 == maxlabel + (labelinc * 2)) then score4=10; end
		if (label4 == maxlabel + (labelinc * 3)) then score4=5; end
		if (label4 == maxlabel + (labelinc * 4)) then score4=1; end
		if (label4 == maxlabel + (labelinc * 5)) then score4=0; end
		
		score5=0;
		if (label5 == maxlabel) then score5=100; end
		if (label5 == maxlabel + labelinc) then score5=50; end
		if (label5 == maxlabel + (labelinc * 2)) then score5=10; end
		if (label5 == maxlabel + (labelinc * 3)) then score5=5; end
		if (label5 == maxlabel + (labelinc * 4)) then score5=1; end
		if (label5 == maxlabel + (labelinc * 5)) then score5=0; end

		score6=0;
		if (label6 == maxlabel) then score6=100; end
		if (label6 == maxlabel + labelinc) then score6=50; end
		if (label6 == maxlabel + (labelinc * 2)) then score6=10; end
		if (label6 == maxlabel + (labelinc * 3)) then score6=5; end
		if (label6 == maxlabel + (labelinc * 4)) then score6=1; end
		if (label6 == maxlabel + (labelinc * 5)) then score6=0; end	
		
	
		
			while label1 == label2 or label1 == label3 or label1 == label4 or label1 == label5 or label1 == label6 or label2 == label3 or label2 == label4 or label2 == label5 or label2 == label6 or label3 == label4 or label3 == label5 or label3 == label6 or label4 == label5 or label4 == label6 or label5 == label6 do
				if label1 == label2 then label2 = label2 + labelinc; end
				if label1 == label3 then label3 = label3 + labelinc; end
				if label1 == label4 then label4 = label4 + labelinc; end 
				if label1 == label5 then label5 = label5 + labelinc; end
			    if label1 == label6 then label6 = label6 + labelinc; end
			    if label2 == label3 then label3 = label3 + labelinc; end
			    if label2 == label4 then label4 = label4 + labelinc; end
			    if label2 == label5 then label5 = label5 + labelinc; end
			    if label2 == label6 then label6 = label6 + labelinc; end
			    if label3 == label4 then label4 = label4 + labelinc; end
			    if label3 == label5 then label5 = label5 + labelinc; end
			    if label3 == label6 then label6 = label6 + labelinc; end
			    if label4 == label5 then label4 = label4 + labelinc; end
		   	    if label4 == label6 then label6 = label6 + labelinc; end
		        if label5 == label6 then label6 = label6 + labelinc; end	
		    end
	
		
		
		
	    --Answer 1
		if (resposta == current.answer1) then qtanswer1Label = autoWrappedText(current.qtanswer1, nil, 20, {240, 0, 10}, 500); currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score1)); else qtanswer1Label = autoWrappedText(current.qtanswer1, nil, 20, {255, 255, 255}, 500); end
		qtanswer1Label.y = label1;
		qtanswer1Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer1Label)
		
		if (resposta == current.answer1) then score1Label = autoWrappedText(score1, nil, 20, {240, 0, 10}, 500); else score1Label = autoWrappedText(score1, nil, 20, {255, 255, 255}, 500); end
		score1Label.y = label1;
		score1Label.x = startscore;
		popUpAnwserGroup:insert(score1Label)
		
		if (resposta == current.answer1) then answer1 = autoWrappedText(current.answer1, nil, 20, {240, 0, 10}, 500); else answer1 = autoWrappedText(current.answer1, nil, 20, {255, 255, 255}, 450); end
		answer1.y = label1;
		answer1.x = startlabel;
		popUpAnwserGroup:insert(answer1)
		
		
		
		
		--Answer 2
		if (resposta == current.answer2) then qtanswer2Label = autoWrappedText(current.qtanswer2, nil, 20, {240, 0, 10}, 270); currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score2));  else qtanswer2Label = autoWrappedText(current.qtanswer2, nil, 20, {255, 255, 255}, 500); end
		qtanswer2Label.y = label2;
		qtanswer2Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer2Label)
		
		if (resposta == current.answer2) then score2Label = autoWrappedText(score2, nil, 20, {240, 0, 10}, 450); else score2Label = autoWrappedText(score2, nil, 20, {255, 255, 255}, 500); end
		score2Label.y = label2;
		score2Label.x = startscore;
		popUpAnwserGroup:insert(score2Label)


		if (resposta == current.answer2) then answer2 = autoWrappedText(current.answer2, nil, 20, {240, 0, 10}, 270); else answer2 = autoWrappedText(current.answer2, nil, 20, {255, 255, 255}, 500); end
		answer2.y = label2;
		answer2.x = startlabel;
		popUpAnwserGroup:insert(answer2)
		
		
		
		
		--Answer 3
		if (resposta == current.answer3) then qtanswer3Label = autoWrappedText(current.qtanswer3, nil, 20, {240, 0, 10}, 270);  currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score3)); 	else qtanswer3Label = autoWrappedText(current.qtanswer3, nil, 20, {255, 255, 255}, 500); end
		qtanswer3Label.y = label3;
		qtanswer3Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer3Label)
		
		if (resposta == current.answer3) then score3Label = autoWrappedText(score3, nil, 20, {240, 0, 10}, 500); else score3Label = autoWrappedText(score3, nil, 20, {255, 255, 255}, 500); end
		score3Label.y = label3;
		score3Label.x = startscore;
		popUpAnwserGroup:insert(score3Label)

		if (resposta == current.answer3) then answer3 = autoWrappedText(current.answer3, nil, 20, {240, 0, 10}, 500); else answer3 = autoWrappedText(current.answer3, nil, 20, {255, 255, 255}, 500); end
		answer3.y = label3;
		answer3.x = startlabel;
		popUpAnwserGroup:insert(answer3)
		
		

        --Answer 4
		if (resposta == current.answer4) then qtanswer4Label = autoWrappedText(current.qtanswer4, nil, 20, {240, 0, 10}, 500);  currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score4)); 	else qtanswer4Label = autoWrappedText(current.qtanswer4, nil, 20,{255, 255, 255}, 500); end
		qtanswer4Label.y = label4;
		qtanswer4Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer4Label)
		
		if (resposta == current.answer4) then score4Label = autoWrappedText(score4, nil, 20, {240, 0, 10}, 500); else score4Label = autoWrappedText(score4, nil, 20, {255, 255, 255}, 500); end
		score4Label.y = label4;
		score4Label.x = startscore;
		popUpAnwserGroup:insert(score4Label)

		if (resposta == current.answer4) then answer4 = autoWrappedText(current.answer4, nil, 20, {240, 0, 10}, 500); else answer4 = autoWrappedText(current.answer4, nil, 20, {255, 255, 255}, 500); end
		answer4.y = label4;
		answer4.x = startlabel;
		popUpAnwserGroup:insert(answer4)
		
		
		
		--Answer 5
		if (resposta == current.answer5) then qtanswer5Label = autoWrappedText(current.qtanswer5, nil, 20, {240, 0, 10}, 500);  currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score5)); 	else qtanswer5Label = autoWrappedText(current.qtanswer5, nil, 20, {255, 255, 255}, 500); end
		qtanswer5Label.y = label5;
		qtanswer5Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer5Label)
		
		if (resposta == current.answer5) then score5Label = autoWrappedText(score5, nil, 20, {240, 0, 10}, 500); else score5Label = autoWrappedText(score5, nil, 20, {255, 255, 255}, 500); end
		score5Label.y = label5;
		score5Label.x = startscore;
		popUpAnwserGroup:insert(score5Label)

		if (resposta == current.answer5) then answer5 = autoWrappedText(current.answer5, nil, 20, {240, 0, 10}, 500); else answer5 = autoWrappedText(current.answer5, nil, 20, {255, 255, 255}, 500); end
		answer5.y = label5;
		answer5.x = startlabel;
		popUpAnwserGroup:insert(answer5)
		
		--Answer 6
		if (resposta == current.answer6) then qtanswer6Label = autoWrappedText(current.qtanswer6, nil, 20, {240, 0, 10}, 500); currentScore:setScore (tonumber(currentScore.getScore())+tonumber(score6)); 	else qtanswer6Label = autoWrappedText(current.qtanswer6, nil, 20, {255, 255, 255}, 500); end
		qtanswer6Label.y = label6;
		qtanswer6Label.x = startvotes;
		popUpAnwserGroup:insert(qtanswer6Label)
		
		if (resposta == current.answer6) then score6Label = autoWrappedText(score6, nil, 20, {240, 0, 10}, 500); else score6Label = autoWrappedText(score6, nil, 20, {255, 255, 255}, 500); end
		score6Label.y = label6;
		score6Label.x = startscore;
		popUpAnwserGroup:insert(score6Label)

        if (resposta == current.answer6) then answer6 = autoWrappedText(current.answer6, nil, 20, {240, 0, 10}, 500); else answer6 = autoWrappedText(current.answer6, nil, 20, {255, 255, 255}, 500); end
		answer6.y = label6;
		answer6.x = startlabel;
		popUpAnwserGroup:insert(answer6)

		
		local scoreDisplay = display.newText (currentScore:getScore(), 0, 625, "Helvetica", 32)
		scoreDisplay:setTextColor (255,255,0)
		scoreDisplay.x=545	;
		
		popUpAnwserGroup:insert(scoreDisplay)
		
		local i = 1;
		local progress = nil;
		while (i < 30) do
				--print ('currentQuestionNumber =' .. currentQuestionNumber);
				if (currentQuestionNumber >= i) then
				--	print('currentQuestionNumber < i')
					progress = display.newImage("images/progress_on.png", 10, 13);
					progress:setReferencePoint(display.CenterReferencePoint);
					progress.x = 395+i*10; progress.y = 417;
					popUpAnwserGroup:insert(progress);
				else
				--	print('currentQuestionNumber < i')
					progress = display.newImage("images/progress_off.png", 10, 13);
					progress:setReferencePoint(display.CenterReferencePoint);
					progress.x = 395+i*10; progress.y = 417;
					popUpAnwserGroup:insert(progress);	
				end
				i = i + 1;
		end
		
		
		 
		transition.to(popUpAnwserGroup, {time=400, y = 0, alpha=1 })
		
	end

	--[[Get List of Questions from Server ]]
	UrlLoader:new("http://localhost/intuition.json", callback)
--	UrlLoader:new("http://tudoporaqui.com.br/intuition/getquestions.php", callback)
	
	return g
end