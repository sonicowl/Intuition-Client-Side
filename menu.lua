module(..., package.seeall)

display.setStatusBar( display.HiddenStatusBar ) 

function new()
	
	local localGroup = display.newGroup();
	
	local bg = display.newImageRect("images/bg.png", _W, _H);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	local logo = display.newImageRect("images/logo.png", 265, 61);
	logo:setReferencePoint(display.CenterReferencePoint);
	logo.x = _W/2 - 3; logo.y = logo.height+20;

	local play_btn = display.newImageRect("images/btn_new_game.png", 270, 58);
	play_btn:setReferencePoint(display.CenterReferencePoint);
	play_btn.x = _W/2; play_btn.y = _H/4 + play_btn.height;
	play_btn.scene = "game";
	
	
	local instructions_btn = display.newImageRect("images/btn_instructions.png", 270, 58);
	instructions_btn:setReferencePoint(display.CenterReferencePoint);
	instructions_btn.x = _W/2; instructions_btn.y = play_btn.y + play_btn.height;
	instructions_btn.scene = "instructions";
	
	
	local leaderboard_btn = display.newImageRect("images/btn_leaderboard.png", 270, 58);
	leaderboard_btn:setReferencePoint(display.CenterReferencePoint);
	leaderboard_btn.x = _W/2; leaderboard_btn.y = instructions_btn.y + instructions_btn.height;
	leaderboard_btn.scene = "instructions";

	local achievements_btn = display.newImageRect("images/btn_achievements.png", 270, 58);
	achievements_btn:setReferencePoint(display.CenterReferencePoint);
	achievements_btn.x = _W/2; achievements_btn.y = leaderboard_btn.y + leaderboard_btn.height;
	achievements_btn.scene = "instructions";
	
 	local logic_diner = nil;
	
	localGroup:insert(bg);
	localGroup:insert(logo);
	localGroup:insert(play_btn);
	localGroup:insert(instructions_btn)
	localGroup:insert(leaderboard_btn)
	localGroup:insert(achievements_btn)
	
	function changeScene(e)
		if(e.phase == "ended") then
			director:changeScene(e.target.scene, "moveFromRight");
		end
	end
	
	play_btn:addEventListener("touch", changeScene);
	instructions_btn:addEventListener("touch", changeScene);
	leaderboard_btn:addEventListener("touch", changeScene);
	achievements_btn:addEventListener("touch", changeScene);
		
	return localGroup;
end