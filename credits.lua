module(..., package.seeall)

function new()
	local localGroup = display.newGroup();
	
	local achievements = display.newImageRect("images/bg.png", _W, _H);
	achievements:setReferencePoint(display.CenterReferencePoint);
	achievements.x = _W/2; achievements.y = _H/2;
	achievements.scene = "menu";
	
	local sceneText = display.newText("Instructions",50,50, nil, 25);
	sceneText:setTextColor(255, 255, 255);
	
	localGroup:insert(achievements);
	localGroup:insert(sceneText);
	
	function changeScene(e)
		if(e.phase == "ended") then
			director:changeScene(e.target.scene);
		end
	end
	
	achievements:addEventListener("touch", changeScene)
	
	return localGroup;
end