module(..., package.seeall)
local util = require("util")

function new()
	local localGroup = display.newGroup();
	local instructions_bg = display.newImageRect("images/bg.png", 640, 959);
	instructions_bg:setReferencePoint(display.CenterReferencePoint);
	instructions_bg.x = _W/2; instructions_bg.y = _H/2;
	instructions_bg.scene = "menu";
	
	local resultsSceneTitle = display.newImageRect("images/title_my_results.png", 260, 49);
	resultsSceneTitle:setReferencePoint(display.CenterReferencePoint);
	resultsSceneTitle.x = _W/2 - 3; 
	resultsSceneTitle.y = resultsSceneTitle.height*1.6; 
	
	--[[local resultsSceneTitle = display.newText("Instructions",30,50, nil, 35);
	resultsSceneTitle:setTextColor(255, 255, 255);--]]
	--[[
	local resultsText = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." --]]
	
	local resultsText = display.newImageRect("images/instructions.png", 298, 115);
	resultsText:setReferencePoint(display.CenterReferencePoint);
	resultsText.x = _W/2 - 3; 
	resultsText.y = resultsSceneTitle.height*3+30;

	local function autoWrappedText(text, font, size, color, width)
	--print("text: " .. text)
	  if text == '' then return false end
	  font = font or native.systemFont
	  size = tonumber(size) or 12
	  color = color or {255, 255, 255}
	  width = width or display.stageWidth

	  local result = display.newGroup()
	  local lineCount = 0
	  -- do each line separately
	  for line in string.gmatch(text, "[^\n]+") do
	    local currentLine = ''
	    local currentLineLength = 0 -- the current length of the string in chars
	    local currentLineWidth = 0 -- the current width of the string in pixs
	    local testLineLength = 0 -- the target length of the string (starts at 0)
	    -- iterate by each word
	    for word, spacer in string.gmatch(line, "([^%s%-]+)([%s%-]*)") do
	      local tempLine = currentLine..word..spacer
	      local tempLineLength = string.len(tempLine)
	      -- test to see if we are at a point to try to render the string
	      if testLineLength > tempLineLength then
	        currentLine = tempLine
	        currentLineLength = tempLineLength
	      else
	        -- line could be long enough, try to render and compare against the max width
	        local tempDisplayLine = display.newText(tempLine, 0, 0, font, size)
	        local tempDisplayWidth = tempDisplayLine.width
	        tempDisplayLine:removeSelf();
	        tempDisplayLine=nil;
	        if tempDisplayWidth <= width then
	          -- line not long enough yet, save line and recalculate for the next render test
	          currentLine = tempLine
	          currentLineLength = tempLineLength
	          testLineLength = math.floor((width*0.9) / (tempDisplayWidth/currentLineLength))
	        else
	          -- line long enough, show the old line then start the new one
	          local newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
	          newDisplayLine:setTextColor(color[1], color[2], color[3])
	          result:insert(newDisplayLine)
	          lineCount = lineCount + 1
	          currentLine = word..spacer
	          currentLineLength = string.len(word)
	        end
	      end
	    end
	    -- finally display any remaining text for the current line
	    local newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
	    newDisplayLine:setTextColor(color[1], color[2], color[3])
	    result:insert(newDisplayLine)
	    lineCount = lineCount + 1
	    currentLine = ''
	    currentLineLength = 0
	  end
	  result:setReferencePoint(display.TopLeftReferencePoint)
	  return result
	end
	
--[[[	local resultsTextFormatted = autoWrappedText(resultsText, nil, 14, {255, 255, 255}, 280)
	resultsTextFormatted.y = 120;
	resultsTextFormatted.x = 30;
	localGroup:insert(resultsTextFormatted);
	
	--]]
	localGroup:insert(instructions_bg);
	localGroup:insert(resultsSceneTitle);
	localGroup:insert(resultsText);
	
	function changeScene(e)
		if(e.phase == "ended") then
			director:changeScene(e.target.scene, "moveFromLeft");
		end
	end
	
	instructions_bg:addEventListener("touch", changeScene)
	
	return localGroup;
end