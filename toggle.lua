-- 
-- Abstract: toggle component
-- 
-- Version: 0.1
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

module(..., package.seeall)

-----------------
-- Helper function for newToggle utility function below
local function newToggleHandler( self, event )

	print( "newToggleHandler " .. event.phase )
	
	local result = true

	local default = self[1]
	local on = self[2]
	
	-- General "onEvent" function overrides onPress and onRelease, if present
	local onEvent = self._onEvent
	
	local buttonEvent = { value = self.value }
	if (self._id) then
		buttonEvent.id = self._id
	end

	local phase = event.phase
	if "began" == phase then

		if onEvent then
			buttonEvent.phase = "press"
			result = onEvent( buttonEvent )
		end

		-- Subsequent touch events will target button even if they are outside the stageBounds of button
		display.getCurrentStage():setFocus( self, event.id )
		self.isFocus = true
		print( "newToggleHandler focused" )
		
	elseif self.isFocus then
		local bounds = self.stageBounds
		local x,y = event.x,event.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if "moved" == phase then
			
		elseif "ended" == phase or "cancelled" == phase then 
			
			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's stageBounds
				if isWithinBounds then
					self.value = self.value == false
					buttonEvent.value = self.value

					default.isVisible = buttonEvent.value == true
					on.isVisible = buttonEvent.value == false
					if onEvent then
						buttonEvent.phase = "release"

						result = onEvent( buttonEvent )
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end

	return result
end


---------------
-- Button class

function newToggle( params )
	local button, default, on, offset
	
	if params.default then
		button = display.newGroup()
		default = display.newImage( params.default )
		button:insert( default, true )
	end
	
	if params.on then
		on = display.newImage( params.on )
		on.isVisible = false
		button:insert( on, true )
	end
	
	if (params.onEvent and ( type(params.onEvent) == "function" ) ) then
		button._onEvent = params.onEvent
	end
		
	-- Set button as a table listener by setting a table method and adding the button as its own table listener for "touch" events
	button.touch = newToggleHandler
	button:addEventListener( "touch", button )

	if params.x then
		button.x = params.x
	end
	
	if params.y then
		button.y = params.y
	end
	
	if params.id then
		button._id = params.id
	end

	button.value = 0

	return button
end


