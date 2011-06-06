module(..., package.seeall)
local util = require("util")
require("Score")
local openfeint = require("openfeint")

function new()
	local localGroup = display.newGroup();
	local gameover_bg = display.newImageRect("images/bg_gameover.png", 768, 1024);
	gameover_bg:setReferencePoint(display.CenterReferencePoint);
	gameover_bg.x = _W/2; gameover_bg.y = _H/2;
	gameover_bg.scene = "menu";
	localGroup:insert(gameover_bg);
	
	local pointer = display.newImage("images/pointer.png", 125, 297);
	pointer.x = _W/2; pointer.y = 447;

	--pointer.rotation = 40;
	--pointer.x = pointer.x-25;
	
	localGroup:insert(pointer);
	
	
	local scoreGroup = display.newGroup()
	
	currentScore = Score:new();
	scoreDisplay = display.newText (currentScore:getScore(),105	, 225, "Helvetica", 32)
	scoreDisplay:setTextColor (255,255,0)
	scoreGroup:insert(scoreDisplay)
	localGroup:insert(scoreGroup);
	
	-------------------------------------------------
	--if currentScore >= 100 then
	--	openfeint.unlockAchievement(123456)
--	end
	
	reputationValue = "Beginner"
	reputationDisplay = display.newText (reputationValue,395, 225, "Helvetica", 32)
	reputationDisplay:setTextColor (255,255,0)
	localGroup:insert(reputationDisplay);
	
	playAgain = display.newImage("images/playagain_btn.png", 230, 66)
	playAgain.x = 405
	playAgain.y = display.contentHeight - 50;
	playAgain.scene = "game";
	localGroup:insert(playAgain)
	
	-- Which Badge does the user Deserve?
	badge = display.newImage("images/badge_nostradamus.png", 103, 114)
	badge.x = 385
	badge.y = display.contentHeight - 320;
	localGroup:insert(badge)
	
	scoreComparissonResult = "You are more intuitive than 20% of the players"
	--scoreComparisson = display.newText (scoreComparissonResult,165, 825, "Helvetica", 25)
	scoreComparisson = autoWrappedText(scoreComparissonResult, nil, 20, {255, 255, 255}, 476)
	scoreComparisson.x = 165;
	scoreComparisson.y = 845;
	localGroup:insert(scoreComparisson);
	
	local homeIcon = display.newImage("images/home_icon.png", 50, 50)
	homeIcon.x = 30
	homeIcon.y = 30
	localGroup:insert(homeIcon)
	
	timer.performWithDelay(1500, movePointer, 0)
	
	pointer:setReferencePoint(display.BottomCenterReferencePoint);
	
	local function movePointer(e)
		-- average top & bottom
		pointer.rotation = 100;
	end
	
	function goToFrontScreen(e)
		if(e.phase == "ended") then
			director:changeScene('menu', "moveFromRight");
			media.playEventSound("button_front.mp3")
		end
	end
	
	function changeScene(e)
		if(e.phase == "ended") then
			director:changeScene(e.target.scene, "moveFromLeft");
		end
	end
	
	function playGame(e)
		if(e.phase == "ended") then
			director:changeScene('game');
		end
	end
	
	gameover_bg:addEventListener("touch", changeScene)
	playAgain:addEventListener("touch", playGame)
	
	return localGroup;
end