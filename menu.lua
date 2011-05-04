module(..., package.seeall)

require "analytics"

display.setStatusBar( display.HiddenStatusBar ) 

function new()
	
	local ui = require("ui")
	local facebook = require("facebook")
	local json = require("Json")
	local tableView = require("tableView")
		
		
	local application_key = "IMZFQTP3ENPDR9IXLIWN"

	analytics.init( application_key )
		
		
	-- Facebook Commands
	local fbCommand			-- forward reference
	local LOGOUT = 1
	local SHOW_DIALOG = 2
	local POST_MSG = 3
	local POST_PHOTO = 4
	local GET_USER_INFO = 5
	local GET_PLATFORM_INFO = 6
	
	
	local appId  = "163467883714718"	-- Add  your App ID here
	local apiKey = "2419fcf7cdc2774b997a5a39f50b7764"	-- Not needed at this time
		
	
	-- This function is useful for debugging problems with using FB Connect's web api,
	-- e.g. you passed bad parameters to the web api and get a response table back
	local function printTable( t, label, level )
		if label then print( label ) end
		level = level or 1

		if t then
			for k,v in pairs( t ) do
				local prefix = ""
				for i=1,level do
					prefix = prefix .. "\t"
				end

				print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
				if type( v ) == "table" then
					print( prefix .. "{" )
					printTable( v, nil, level + 1 )
					print( prefix .. "}" )
				end
			end
		end
	end
	
	--[[
	local StatusMessageY = 420	
	
	local function createStatusMessage( message, x, y )
		-- Show text, using default bold font of device (Helvetica on iPhone)
		local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
		textObject:setTextColor( 255,255,255 )

		-- A trick to get text to be centered
		local group = display.newGroup()
		group.x = x
		group.y = y
		group:insert( textObject, true )

		-- Insert rounded rect behind textObject
		local r = 10
		local roundedRect = display.newRoundedRect( 0, 0, textObject.contentWidth + 2*r, textObject.contentHeight + 2*r, r )
		roundedRect:setFillColor( 55, 55, 55, 190 )
		group:insert( 1, roundedRect, true )

		group.textObject = textObject
		return group
	end

	local statusMessage = createStatusMessage( "   Not connected  ", 0.5*display.contentWidth, StatusMessageY )
	--]]
	
	textObj = display.newText('', 80, 420, native.systemFontBold, 24 )

	local callFacebook = function()
		local facebookListener = function( event )
			if ( "session" == event.type ) then
				if ( "login" == event.phase ) then
					textObj = nil;
					textObj = display.newText('connected', 130, 420, native.systemFontBold, 24 )
					textObj:setTextColor( 255,255,255 )
					
				--[[	local theMessage = "I just took the Zombie Survival Test! I scored " .. score .. " points!"

						facebook.request( "me/feed", "POST", {
						message=theMessage,
						name="Do you think you can beat my score?",
						caption="Play YOURAPPNAME now to find out!",
						link="http://itunes.apple.com/us/app/your-app-name/id1234567890?mt=8",
						picture="http://yoursite.com/yourimage.png" } )--]]
				end
			end
		end 
		facebook.login( appId, facebookListener, { "publish_stream" } )
	end
	
	callFacebook();
	
		
	local localGroup = display.newGroup();
	
	local bg = display.newImageRect("images/bg.png", 640, 959);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	local logo = display.newImageRect("images/logo.png", 265, 61);
	logo:setReferencePoint(display.CenterReferencePoint);
	logo.x = _W/2 - 3; logo.y = logo.height+20;

	local play_btn = display.newImageRect("images/btn_new_game.png", 287, 73);
	play_btn:setReferencePoint(display.CenterReferencePoint);
	play_btn.x = _W/2; play_btn.y = _H/5 + play_btn.height;
	play_btn.scene = "game";
	
	
	local instructions_btn = display.newImageRect("images/btn_instructions.png", 287, 73);
	instructions_btn:setReferencePoint(display.CenterReferencePoint);
	instructions_btn.x = _W/2; instructions_btn.y = play_btn.y + play_btn.height;
	instructions_btn.scene = "instructions";
	
	local results_btn = display.newImageRect("images/btn_results.png", 287, 73);
	results_btn:setReferencePoint(display.CenterReferencePoint);
	results_btn.x = _W/2; results_btn.y = instructions_btn.y + instructions_btn.height;
	results_btn.scene = "results";
	
	local leaderboard_btn = display.newImageRect("images/btn_leaderboard.png", 287, 73);
	leaderboard_btn:setReferencePoint(display.CenterReferencePoint);
	leaderboard_btn.x = _W/2; leaderboard_btn.y = results_btn.y + results_btn.height;
	leaderboard_btn.scene = "instructions";

	
 	local logic_diner = nil;
	
	localGroup:insert(bg);
	localGroup:insert(logo);
	localGroup:insert(play_btn);
	localGroup:insert(instructions_btn)
	localGroup:insert(results_btn);
	localGroup:insert(leaderboard_btn)
	localGroup:insert(textObj)
	
	function changeScene(e)
		if(e.phase == "ended") then
			--[[analytics.logEvent(e.target.scene) --]]
			director:changeScene(e.target.scene, "moveFromRight");
			media.playEventSound("button_front.mp3")
		end
		
	end
	
	play_btn:addEventListener("touch", changeScene);
	instructions_btn:addEventListener("touch", changeScene);
	results_btn:addEventListener("touch", changeScene);
	leaderboard_btn:addEventListener("touch", changeScene);
		
	return localGroup;
end