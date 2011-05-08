Score = class("Score")

-- Init images. This creates a map of characters to the names of their corresponding images.
Score.numbers = { 
	[string.byte("0")] = "0.png",
	[string.byte("1")] = "1.png",
	[string.byte("2")] = "2.png",
	[string.byte("3")] = "3.png",
	[string.byte("4")] = "4.png",
	[string.byte("5")] = "5.png",
	[string.byte("6")] = "6.png",
	[string.byte("7")] = "7.png",
	[string.byte("8")] = "8.png",
	[string.byte("9")] = "9.png",
	[string.byte(" ")] = "space.png",
}

-- score components
Score.theScoreGroup = display.newGroup()
Score.theBackgroundBorder = 10


Score.numbersGroup = display.newGroup()
Score.theScoreGroup:insert(Score.numbersGroup )


-- the current score
Score.theScore = 0

-- the location of the score image


-- initialize the score
-- 		params.x <= X location of the score
-- 		params.y <= Y location of the score
function Score:initialize()
	-- nothing for now
end


-- retrieve score panel info
--		result.x <= current panel x
--		result.y <= current panel y
--		result.xmax <= current panel x max
--		result.ymax <= current panel y max
--		result.contentWidth <= panel width
--		result.contentHeight <= panel height
--		result.score <= current score
function Score:getInfo()
end


-- update display of the current score.
-- this is called by setScore, so normally this should not be called
function Score:update()
	-- remove old numerals
--[[	Score.theScoreGroup:remove(1)

	local numbersGroup = display.newGroup()
	Score.theScoreGroup:insert( numbersGroup )

	-- go through the score, right to left
	local scoreStr = tostring( theScore )

	local scoreLen = string.len( scoreStr )
	local i = scoreLen	


	-- starting location is on the right. notice the digits will be centered on the background
	local x = theScoreGroup.contentWidth
	local y = theScoreGroup.contentHeight / 2
	
	while i > 0 do
		-- fetch the digit
		local c = string.byte( scoreStr, i )
		local digitPath = numbers[c]
		local characterImage = display.newImage( digitPath )


		-- put it in the score group
		Score.numbersGroup:insert( characterImage )
		
		-- place the digit
		characterImage.x = x - characterImage.width / 2
		characterImage.y = y
		x = x - characterImage.width


		-- 
		i = i - 1
	end --]]
end


-- get current score
function Score:getScore()
	return Score.theScore
end


-- set score to value
--	score <= score value
function Score:setScore( score )
	Score.theScore = score
--	Score.update()
end
