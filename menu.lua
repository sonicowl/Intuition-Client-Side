module(..., package.seeall)

require "analytics"

display.setStatusBar( display.HiddenStatusBar ) 

function new()
	local openfeint = require("openfeint")
	---------------------------------------------------------------------------------------------------
	-- NOTE: To create an OpenFeint-enabled game, first log into OpenFeint and create a new OpenFeint 
	-- application. That will give you the "Product Key", "Product Secret" and "Client Application ID" strings that should be 
	-- used in the following lines:

	local of_product_key = "hdYGMSj3JyOYkMGaSFBQ"
	local of_product_secret = "30NR5kz9jzSqyluQR6eO9dlFAA9K5BjXATUOBSUIlI"
	local of_app_id = "296642"

	---------------------------------------------------------------------------------------------------

	if openfeint then
		if ( of_product_key and of_product_secret ) then
			openfeint.init( of_product_key, of_product_secret, "Test Display Name", of_app_id )
		else
			local function onComplete( event )
				system.openURL( "http://www.openfeint.com/developers" )
			end
			native.showAlert( "OpenFeint Init Failed", "To use OpenFeint in your game, you need to get a product key and product secret. This can be done on the OpenFeint website.", { "Learn More" }, onComplete )
		end
	else
		native.showAlert( "OpenFeint Init Failed", "This feature is currently supported on iOS only. To test OpenFeint, create a build for an iOS device or the Xcode Simulator.", { "OK" } )
	end
	
	---------------------------------------------------------------------------------------------------
	
	local ui = require("ui")
	local json = require("Json")
	local tableView = require("tableView")
		
		
	local application_key = "IMZFQTP3ENPDR9IXLIWN"

	analytics.init( application_key )
		
		
	-- Facebook Commands
	--[[local fbCommand			-- forward reference
	local LOGOUT = 1
	local SHOW_DIALOG = 2
	local POST_MSG = 3
	local POST_PHOTO = 4
	local GET_USER_INFO = 5
	local GET_PLATFORM_INFO = 6
	
	
	local appId  = "163467883714718"	-- Add  your App ID here
	local apiKey = "2419fcf7cdc2774b997a5a39f50b7764"	-- Not needed at this time

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
	--[[
	textObj = display.newText('', 80, 420, native.systemFontBold, 24 )

	local callFacebook = function()
		local facebookListener = function( event )
			if ( "session" == event.type ) then
				if ( "login" == event.phase ) then
					textObj = nil;
					textObj = display.newText('connected', 130, 420, native.systemFontBold, 24 )
					textObj:setTextColor( 255,255,255 )

				end
			end
		end 
		facebook.login( appId, facebookListener, { "publish_stream" } )
	end
	
	callFacebook();
	--]]
		
	local localGroup = display.newGroup();
	
	local bg = display.newImage("images/screen1_bg.png", 768, 1024, true);
	bg:setReferencePoint(display.CenterReferencePoint);
	bg.x = _W/2; bg.y = _H/2;
	
	
	local play_btn = display.newImage("images/btn_newtest.png", 702, 70, true);
	play_btn:setReferencePoint(display.CenterReferencePoint);
	play_btn.x = _W/2; play_btn.y = _H/4 + play_btn.height*1.5;
	play_btn.scene = "game";
	
	
	local achievements_btn = display.newImageRect("images/btn_achievements.png", 702, 70);
	achievements_btn:setReferencePoint(display.CenterReferencePoint);
	achievements_btn.x = _W/2; achievements_btn.y = play_btn.y + play_btn.height+30;
	achievements_btn.scene = "instructions";
	
	
	local leaderboard_btn = display.newImageRect("images/btn_leaderboard.png", 702, 70);
	leaderboard_btn:setReferencePoint(display.CenterReferencePoint);
	leaderboard_btn.x = _W/2; leaderboard_btn.y = achievements_btn.y + achievements_btn.height + 30;
	leaderboard_btn.scene = "instructions";
	
	
	local instructions_btn = display.newImageRect("images/btn_instructions.png", 702, 70);
	instructions_btn:setReferencePoint(display.CenterReferencePoint);
	instructions_btn.x = _W/2; instructions_btn.y = leaderboard_btn.y + leaderboard_btn.height + 30;
	instructions_btn.scene = "instructions";

	localGroup:insert(bg);
	localGroup:insert(play_btn);
	localGroup:insert(achievements_btn);
	localGroup:insert(leaderboard_btn)
	localGroup:insert(instructions_btn)
	
--	localGroup:insert(results_btn);
--	localGroup:insert(textObj)
	
	function changeScene(e)
		if(e.phase == "ended") then
			--[[analytics.logEvent(e.target.scene) --]]
			director:changeScene(e.target.scene, "moveFromRight");
			media.playEventSound("button_front.mp3")
		end
		
	end
	
	function goButton(event)
		local options = { 
		  baseUrl = system.ResourceDirectory, 
		  hasBackground = false, 
		  urlRequest = listener 
		}
		
		if event.phase == "ended" then
			native.showWebPopup( "test.html", options )		
		end
	end
	
	local function openOpenFeintLeaderBoard (event)
		if event.phase == "ended" then
			openfeint.launchDashboard('leaderboards')
		end
	end
	
	local function openOpenFeintAchievements(event)
		if event.phase == "ended" then
			openfeint.launchDashboard('achievements')
		end
	end
	
	
	play_btn:addEventListener("touch", changeScene);
 	instructions_btn:addEventListener("touch", changeScene);
	achievements_btn:addEventListener("touch", openOpenFeintAchievements);
	leaderboard_btn:addEventListener("touch", openOpenFeintLeaderBoard);
	return localGroup;
end