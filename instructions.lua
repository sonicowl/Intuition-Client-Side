module(..., package.seeall)
local util = require("util")

function new()
	local localGroup = display.newGroup();
	local instructions_bg = display.newImage("images/bg_instructions.png", 768, 1024, true);
	instructions_bg:setReferencePoint(display.CenterReferencePoint);
	instructions_bg.x = _W/2; instructions_bg.y = _H/2;
	
	local play_btn = display.newImage("images/btn_play.png", 321, 120, true);
	play_btn:setReferencePoint(display.CenterReferencePoint);
	play_btn.x = _W/2; play_btn.y = _H/4 + play_btn.height*5.5;
	play_btn.scene = "game";

	localGroup:insert(instructions_bg);
	localGroup:insert(play_btn);

	local homeIcon = display.newImage("images/home_icon.png", 50, 50)
	homeIcon.x = 30
	homeIcon.y = 30
	localGroup:insert(homeIcon)
	
	function goToFrontScreen(e)
		if(e.phase == "ended") then
			director:changeScene('menu', "moveFromLeft");
			media.playEventSound("button_front.mp3")
		end
	end
	
	function playGame(e)
		if(e.phase == "ended") then
			director:changeScene('game', "moveFromRight");
		end
	end
	
	play_btn:addEventListener("touch", playGame)
	homeIcon:addEventListener("touch", goToFrontScreen)
	
	return localGroup;
end