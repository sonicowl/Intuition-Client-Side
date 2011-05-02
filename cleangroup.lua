------------------------------------------------------------------------        
--
-- 	cleangroup.lua
--	==============
--
-- 	version 1.1
--
--
--	USAGE
--	-----
--
--	VERY IMPORTANT!!!
--	---
-- 	In order for this to work properly (and NOT cause potential errors in
--	your code), you MUST place the following at the TOP of your main.lua
--	before any other 'require' statments.
--
--
-- 	require( "cleangroup" )
--
--
--  From there, whenever you want to ensure a group (and all of it's
--	children display objects AND children groups) are completely cleaned
--	out, simply call:
--
--	cleanGroup( myGroup )
--	myGroup = nil
--
--	---------
--	CHANGELOG
--	---------
--
--	1.1 - Added a check for touch listeners before removing an object
--		  or group (via Jonathan Beebe)
--
------------------------------------------------------------------------        

--

------------------------------------------------------------------------        
-- REPLACEMENT FOR display.newGroup() to fix memory leak issues
-- in group:removeSelf()
--
-- 		Courtesy of 'p120ph37' from the Corona SDK Forums.
--
------------------------------------------------------------------------

local oldNewGroup = display.newGroup
display.newGroup = function( ... )
	local group = oldNewGroup( ... )
	local oldRemoveSelf = group.removeSelf
	
	group.removeSelf = function( self )
  
		if self.numChildren then
			for i = self.numChildren, 1, -1 do
				self[i]:scale(0.1,0.1)
				
				-- check to see if this object has any touch listeners
				if self[i].touch then
					self[i]:removeEventListener( "touch", self[i] )
					self[i].touch = nil
				end
				
				self[i]:removeSelf()
			end
		end
		
		oldRemoveSelf( self )
  	end
  
  	group.remove = function( self, o )
  		if type( o ) == 'number' then
			self[o]:scale(0.1,0.1)
			
			-- check to see if this object has any touch listeners
			if self[o].touch then
				self[o]:removeEventListener( "touch", self[o] )
				self[o].touch = nil
			end
			
			self[o]:removeSelf()
		else
			o:scale(0.1,0.1)
			
			-- check to see if this object has any touch listeners
			if o.touch then
				o:removeEventListener( "touch", o )
				o.touch = nil
			end
			
			o:removeSelf()
    	end
  	end
	
	return group
end

-- patch stage object to proxy stage:remove( o ) to o:removeSelf()
display.getCurrentStage().remove = function( self, o )
	if type( o ) == 'number' then
		self[o]:scale(0.1,0.1)
		
		-- check to see if this object has any touch listeners
		if self[o].touch then
			self[o]:removeEventListener( "touch", self[o] )
			self[o].touch = nil
		end
		
		self[o]:removeSelf()
	else
		o:scale(0.1,0.1)
		
		-- check to see if this object has any touch listeners
		if o.touch then
			o:removeEventListener( "touch", o )
			o.touch = nil
		end
		
		o:removeSelf()
	end
end

------------------------------------------------------------------------        
-- cleanGroup() FUNCTION TO
--
-- 		Courtesy of 'FrankS' from the Corona SDK Forums.
--
--		It's a modified version of the cleanGroups() function found in
--		Ricardo Rauber's Director Class--so special thanks to him
--		as well.
--
------------------------------------------------------------------------


local coronaMetaTable = getmetatable(display.getCurrentStage())
 
-- Returns whether aDisplayObject is a Corona display object.
-- note that all Corona types seem to share the same metatable, which is used for the test.
-- @param aDisplayObject table - possible display object.
-- @return boolean - true if object is a display object
-- Courtesy of 'FrankS' from the Corona SDK Forums
local isDisplayObject = function(aDisplayObject)
	return (type(aDisplayObject) == "table" and getmetatable(aDisplayObject) == coronaMetaTable)
end

function cleanGroup( objectOrGroup )
    if(not isDisplayObject(objectOrGroup)) then return end
    
    if objectOrGroup.numChildren then
		-- we have a group, so first clean that out
		while objectOrGroup.numChildren > 0 do
			-- clean out the last member of the group (work from the top down!)
			cleanGroup ( objectOrGroup[objectOrGroup.numChildren])
		end
    end
    
    -- we have either an empty group or a normal display object - remove it
    objectOrGroup:scale(0.1,0.1)
    
    -- check if object/group has an attached touch listener
    if objectOrGroup.touch then
    	objectOrGroup:removeEventListener( "touch", objectOrGroup )
    	objectOrGroup.touch = nil
    end
    
    objectOrGroup:removeSelf()
    
    return
end