module(..., package.seeall)

if sprite == nil then require "sprite" end
if string == nil then require "string" end


--[[
----------------------------------------------------------------
TEXT CANDY FOR CORONA SDK
----------------------------------------------------------------
PRODUCT  :		TEXT CANDY EFFECTS ENGINE
VERSION  :		1.0.02
AUTHOR   :		MIKE DOGAN / X-PRESSIVE.COM
WEB SITE :		http:www.x-pressive.com
SUPPORT  :		info@x-pressive.com
PUBLISHER:		X-PRESSIVE.COM
COPYRIGHT:		(C)2011 MIKE DOGAN GAMES & ENTERTAINMENT

----------------------------------------------------------------

PLEASE NOTE:
A LOT OF HARD AND HONEST WORK HAS BEEN SPENT
INTO THIS PROJECT AND WE'RE STILL WORKING HARD
TO IMPROVE IT FURTHER.
IF YOU DID NOT PURCHASE THIS SOURCE LEGALLY,
PLEASE ASK YOURSELF IF YOU DID THE RIGHT AND
GET A LEGAL COPY (YOU'LL BE ABLE TO RECEIVE
ALL FUTURE UPDATES FOR FREE THEN) TO HELP
US CONTINUING OUR WORK. THE PRICE IS REALLY
FAIR. THANKS FOR YOUR SUPPORT AND APPRECIATION.

FOR FEEDBACK & SUPPORT, PLEASE CONTACT:
SUPPORT@X-PRESSIVE.COM

]]--


----------------------------------------------------------------
-- MAY BE CHANGED: 
----------------------------------------------------------------
local debug			= true		-- ENABLE / DISABLE CONSOLE MESSAGES
local newLineChar	= "|"		-- NEW LINE CHAR -USE THIS TO FORCE LINE BREAKS IN TEXTS



----------------------------------------------------------------
-- DO NOT CHANGE ANYTHING BELOW! 
----------------------------------------------------------------

local Rnd  	  	= math.random
local Seed 	  	= math.randomseed
local Ceil 	  	= math.ceil
local Floor	  	= math.floor
local Sin	  	= math.sin
local Cos	  	= math.cos
local Rad	  	= math.rad
local Mod	  	= math.mod
local PI 	  	= 4*math.atan(1)
local GetTimer	= system.getTimer

local Charsets	 = {}
local effectList = {}
local ObjectList = {}

DEFORM_SHAKE		= 0
DEFORM_WAVE_Y		= 1
DEFORM_WAVE_SCALE	= 2
DEFORM_MIRROR		= 3
DEFORM_ZIGZAG		= 4
DEFORM_SQUEEZE		= 5
DEFORM_CIRCLE		= 6

-- PRIVATE FUNCTIONS
local _Animate
local _SetWrappedTextData
local _UpdateText
local _AppyProperties
local _DoDeform
local _StartInOutTransition
local _StopInOutTransition
local _RemoveInOutTransition
local _AutoScroll
local _AnimAlphaFade
local _ScrollbarTouched
local _Marquee

if debug then print(); print(); print("--> TEXT FX SYSTEM READY."); end

----------------------------------------------------------------
-- ENABLE / DISABLE DEBUG
----------------------------------------------------------------
function EnableDebug(state)
	debug = state == true and true or false
end

----------------------------------------------------------------
-- LOAD A CHARSET
----------------------------------------------------------------
function AddCharset(name, dataFile, imageFile, charOrder, spaceWidth, charSpacing, lineSpacing)

	if string.sub(dataFile,string.len(dataFile)-3) == ".lua" then dataFile = string.sub(dataFile,1,string.len(dataFile)-4) end

	local Data  = require(dataFile).getSpriteSheetData()
	   if Data  == nil then print("!!! TextFX.AddCharset(): Could not find data file "..dataFile..".lua"); return end

	if imageFile == "" then imageFile = dataFile..".png" end
	if string.sub(imageFile,string.len(imageFile)-3) ~= ".png" then imageFile = imageFile..".png" end

	local Sheet = sprite.newSpriteSheetFromData( imageFile, Data )
	   if Sheet == nil then print("!!! TextFX.AddCharset(): Could not find image file "..imageFile.."."); return end

	local Set   = sprite.newSpriteSet(Sheet, 1, string.len(charOrder))

	charOrder = string.gsub (charOrder, " ", "")-- REMOVE SPACES

	Charsets[name] = {}
	Charsets[name].name 		= name
	Charsets[name].isVector		= false
	Charsets[name].dataFile 	= dataFile
	Charsets[name].imageFile 	= imageFile
	Charsets[name].Data			= Data
	Charsets[name].Sheet		= Sheet
	Charsets[name].Set			= Set
	Charsets[name].charString	= charOrder
	Charsets[name].numChars		= string.len(charOrder)
	Charsets[name].Chars 		= {}
	Charsets[name].lineHeight	= 0
	Charsets[name].spaceWidth	= spaceWidth
	Charsets[name].charSpacing	= charSpacing
	Charsets[name].lineSpacing	= lineSpacing
	Charsets[name].scale		= 1.0

	-- THE CHARS
	local c, n, i
	for i = 1, string.len(charOrder) do
		c = string.sub (charOrder,i,i)
		n = string.byte(c)
		Charsets[name].Chars[n] = {}
		Charsets[name].Chars[n].frame 	= i
		Charsets[name].Chars[n].offY 	= 0
		Charsets[name].Chars[n].width 	= Charsets[name].Data.frames[i].spriteSourceSize.width
		Charsets[name].Chars[n].height 	= Charsets[name].Data.frames[i].spriteSourceSize.height
		Charsets[name].Chars[n].imgName = Charsets[name].Data.frames[i].name
		-- GET HEIGHT OF TALLEST CHAR
		if Charsets[name].Chars[n].height > Charsets[name].lineHeight then Charsets[name].lineHeight = Charsets[name].Chars[n].height end
	end

	-- SPACE CHAR DATA
	Charsets[name].Chars[32] = {}
	Charsets[name].Chars[32].frame  = 0
	Charsets[name].Chars[32].offY   = 0
	Charsets[name].Chars[32].width  = spaceWidth
	Charsets[name].Chars[32].height = Charsets[name].lineHeight

	-- NEW LINE CHAR DATA
	Charsets[name].Chars[13] = {}
	Charsets[name].Chars[13].frame  = 0
	Charsets[name].Chars[13].offY   = 0
	Charsets[name].Chars[13].width  = 0
	Charsets[name].Chars[13].height = 0
	
	if debug then print ("--> TextFX.AddCharset(): ADDED CHARSET '"..name.."' ("..Charsets[name].numChars.." CHARS)") end
end

----------------------------------------------------------------
-- ADD A VECTOR FONT
----------------------------------------------------------------
function AddVectorFont(fontName, charOrder, fontSize, charSpacing, lineSpacing)

	local Temp

	Charsets[fontName] = {}
	Charsets[fontName].name 		= fontName
	Charsets[fontName].charString	= charOrder
	Charsets[fontName].numChars		= string.len(charOrder)
	Charsets[fontName].Chars 		= {}
	Charsets[fontName].lineHeight	= 0
	Charsets[fontName].charSpacing	= charSpacing
	Charsets[fontName].lineSpacing	= lineSpacing
	Charsets[fontName].scale		= 1.0
	--
	Charsets[fontName].isVector		= true
	Charsets[fontName].fontSize		= fontSize

	-- THE CHARS
	local c, n, i
	for i = 1, string.len(charOrder) do
		c = string.sub (charOrder,i,i)
		n = string.byte(c)
		
		Temp = display.newText( c, 0, 0, fontName, fontSize )
		Charsets[fontName].Chars[n] = {}
		Charsets[fontName].Chars[n].frame 	= 0
		Charsets[fontName].Chars[n].offY 	= 0
		Charsets[fontName].Chars[n].width 	= Temp.width
		Charsets[fontName].Chars[n].height 	= Temp.height
		Charsets[fontName].Chars[n].imgName = ""
		Temp:removeSelf()
		-- GET HEIGHT OF TALLEST CHAR
		if Charsets[fontName].Chars[n].height > Charsets[fontName].lineHeight then Charsets[fontName].lineHeight = Charsets[fontName].Chars[n].height end
	end

	-- SPACE CHAR DATA
	Temp = display.newText( " ", 0, 0, fontName, fontSize )
	Charsets[fontName].Chars[32] = {}
	Charsets[fontName].Chars[32].frame  = 0
	Charsets[fontName].Chars[32].offY   = 0
	Charsets[fontName].Chars[32].width  = Temp.width
	Charsets[fontName].Chars[32].height = Charsets[fontName].lineHeight
	Charsets[fontName].spaceWidth	= Temp.width
	Temp:removeSelf()

	-- NEW LINE CHAR DATA
	Charsets[fontName].Chars[13] = {}
	Charsets[fontName].Chars[13].frame  = 0
	Charsets[fontName].Chars[13].offY   = 0
	Charsets[fontName].Chars[13].width  = 0
	Charsets[fontName].Chars[13].height = 0

	if debug then print ("--> TextFX.AddVectorFont(): ADDED VECTOR FONT '"..fontName.."'") end
end

----------------------------------------------------------------
-- SCALE A CHARSET
----------------------------------------------------------------
function ScaleCharset(fontName, scale)
	local Charset = Charsets[fontName]
	if Charset == nil then print("!!! TextFX.ScaleCharset(): CHARSET '"..fontName.."' NOT FOUND."); return end
	
	Charset.lineHeight		= 0
	Charset.scale			= scale
	Charset.Chars[32].width = Charset.spaceWidth  * scale
	
	local c, n, i
	-- BITMAP FONT?
	if Charset.isVector ~= true then
		for i = 1, string.len(Charset.charString) do
			c = string.sub   (Charset.charString,i,i)
			n = string.byte  (c)
			Charset.Chars[n].width 	= Charset.Data.frames[i].spriteSourceSize.width  * scale
			Charset.Chars[n].height = Charset.Data.frames[i].spriteSourceSize.height * scale
			-- GET HEIGHT OF TALLEST CHAR
			if Charset.Chars[n].height > Charset.lineHeight then Charset.lineHeight = Charset.Chars[n].height end
		end
	-- VECTOR FONT?
	else
		local Temp
		for i = 1, string.len(Charset.charString) do
			c = string.sub   (Charset.charString,i,i)
			n = string.byte  (c)
			Temp = display.newText( c, 0, 0, Charset.name, Charset.fontSize * scale )
			Charset.Chars[n].width 	= Temp.width
			Charset.Chars[n].height = Temp.height
			Temp:removeSelf()
			-- GET HEIGHT OF TALLEST CHAR
			if Charset.Chars[n].height > Charset.lineHeight then Charset.lineHeight = Charset.Chars[n].height end
		end
	end
	
	-- REDRAW TEXTS
	c = 0
	for i = 1, #ObjectList do 
		if ObjectList[i].fontName == fontName then c = c + 1; _DrawChars(ObjectList[i]) end
	end

	if debug then print ("--> TextFX.ScaleCharset(): CHARSET SCALED. "..c.." TEXT OBJECTS AFFECTED.\n\n") end
end

----------------------------------------------------------------
-- REMOVE A CHARSET (ALSO DELETES ALL TEXTS USING IT)
----------------------------------------------------------------
function RemoveCharset(fontName)
	 if Charsets[fontName] == nil then print("!!! TextFX.RemoveCharset(): CHARSET '"..fontName.."' NOT FOUND."); return end

	if debug then print ("\n\n--> TextFX.RemoveCharset(): REMOVING CHARSET '"..fontName.."'...") end

	local i, Object

	-- REMOVE THIS CHARSET (OR ALL, IF NO NAME SPECIFIED)
	for i = #ObjectList, 1, -1 do
		if fontName == ObjectList[i].fontName then DeleteText(ObjectList[i]) end
	end
	
	-- UNLOAD FONT	
	Charsets[fontName].Chars 	= nil
	Charsets[fontName].Data 	= nil
	Charsets[fontName].Set   	= nil
	Charsets[fontName].Sheet:dispose()
	Charsets[fontName].dataFile = nil
	Charsets[fontName].imageFile= nil
	Charsets[fontName]		 	= nil

	if debug then print ("--> TextFX.RemoveCharset(): CHARSET DELETED.\n\n") end
end

----------------------------------------------------------------
-- REMOVE ALL
----------------------------------------------------------------
function CleanUp()
	-- REMOVES ALL CHARSETS, EFFECTS, TEXTS ETC.
	local pName, pValue
	for pName,pValue in pairs(Charsets) do RemoveCharset(pName) end				
	collectgarbage("collect")
end

----------------------------------------------------------------
-- SET CHAR OFFSET
----------------------------------------------------------------
function SetCharYOffset(fontName, char, offY)
	local Charset = Charsets[fontName] ; if Charset == nil then print("!!! TextFX.SetCharOffset(): CHARSET '"..fontName.."' NOT FOUND."); return end
	local Char	  = Charset.Chars[string.byte(char)]; if Char    == nil then print("!!! TextFX.SetCharOffset(): CHAR '"..char.."' NOT INCLUDED IN CHARSET '"..fontName.."'!"); return end
	if offY ~= nil then Char.offY = offY end
end

----------------------------------------------------------------
-- CREATE A TEXT OBJECT
----------------------------------------------------------------
function CreateText(Properties)

	local Charset = Charsets[Properties.fontName]; if Charset == nil then print("!!! TextFX.CreateText(): CHARSET "..fontName.." NOT FOUND."); return end
	
	local i, name, value
	
	-- CREATE GROUP
	local Group		= display.newGroup()
	Group.name 		= "FXText"
	table.insert	(ObjectList, Group)

	-- CREATE GROUP TO HOLD BACKGROUND
	local Tmp = display.newGroup()
	Group:insert(1, Tmp)

	-- CREATE GROUP TO HOLD CHARS
	local Tmp = display.newGroup()
	Group:insert(2, Tmp)

	-- CREATE ORIGIN SYMBOL
	local Img	= display.newCircle(0,0,8)
	Img:setFillColor(255,255,0)
	Img.name	= "Origin"
	Group:insert(3, Img)



	-- DEFINE METHODS
	
	-- SET TEXT ------------------------------------------------
	function Group:setText (txt, wrapWidth)
		-- STOP MARQUEE ANIMATION, IF ONE
		self:stopMarquee()
		
		if wrapWidth ~= nil then self.wrapWidth = wrapWidth end
		if txt == self.text then return end
		self.text		   = txt
		_DrawChars 			(self) 
	end

	-- GET TEXT ------------------------------------------------
	function Group:getText 	  	() 		return self.text end
	
	-- GET NUMBER OF LINES -------------------------------------
	function Group:getNumLines	() 		return #self.wrappedLines end
	
	-- GET TEXT OF A LINE --------------------------------------
	function Group:getLine	   	(num) 	return self.wrappedLines[num] end
	
	-- GET WIDTH OF A LINE -------------------------------------
	function Group:getLineWidth	(num) 	return self.lineWidths  [num] end

	-- GET CURRENT START LINE ----------------------------------
	function Group:getScroll	() 	return self.startLine end

	-- SET FONT ------------------------------------------------
	function Group:changeFont	(fontName) 	
		local CS = Charsets[fontName]; if CS == nil then print("!!! TextFX:setCharset(): CHARSET "..fontName.." NOT FOUND."); return end
		self.fontName = fontName 
		if CS.charSpacing ~= nil then self.charSpacing = CS.charSpacing end
		if CS.lineSpacing ~= nil then self.lineSpacing = CS.lineSpacing end
		if CS.fontSize    ~= nil then self.fontSize	   = CS.fontSize    end
		_DrawChars	(self) 
	end

	-- SET CURRENT START LINE ----------------------------------
	function Group:setScroll	(num) 	
		self.startLine = Ceil(num)
		_DrawChars			(self)
		if Group.Scrollbar ~= nil then
			self.ScrollButton.y = (self.startLine  / self.maxScroll) * (self.Scrollbar.height - self.ScrollButton.height)
			if self.startLine == 1 then self.ScrollButton.y = 0 end
		end
	end

	-- SCROLL UP / DOWN ----------------------------------------
	function Group:scroll (value) 
		self.startLine = self.startLine + Ceil(value)
		_DrawChars			(self)
		if Group.Scrollbar ~= nil then
			self.ScrollButton.y = (self.startLine  / self.maxScroll) * (self.Scrollbar.height - self.ScrollButton.height)
			if self.startLine == 1 then self.ScrollButton.y = 0 end
		end
	end

	-- GET MAX SCROLL ------------------------------------------
	function Group:getMaxScroll	() 	return self.maxScroll end

	-- GET WIDTH OF A LINE -------------------------------------
	function Group:getLineWidth	(num) 	return self.lineWidths  [num] end

	-- SET TEXT ORIGIN -----------------------------------------
	function Group:setOrigin (originX, originY)
		self.originX 	   = string.upper(originX)
		self.originY 	   = string.upper(originY)
		_DrawChars			(self)
	end

	-- SET TEXT FLOW -------------------------------------------
	function Group:setTextFlow (textFlow)
		self.textFlow 	   = string.upper(textFlow)
		_DrawChars			(self)
	end

	-- APPLY PROPERTIES ----------------------------------------
	function Group:setProperties(Properties)
		_ApplyProperties 	(self, Properties)
		_DrawChars			(self)
	end

	-- APPLY PROPERTY ------------------------------------------
	function Group:setProperty(name, value)
		self[name]	 	   = value
		_DrawChars			(self)
	end

	-- GET PROPERTY --------------------------------------------
	function Group:getProperty(name)
		return self[name]
	end
	
	-- VECTOR FONT: SET COLOR ----------------------------------
	function Group:setColor(R,G,B,A)
		if Charsets[self.fontName].isVector == true then
			self.Color[1] = R ~= nil and R or 255
			self.Color[2] = G ~= nil and G or 255
			self.Color[3] = B ~= nil and B or 255
			self.Color[4] = A ~= nil and A or 255
			local i
			local n = self[2].numChildren
			for i = 1, n do self[2][i]:setTextColor( self.Color[1],self.Color[2],self.Color[3],self.Color[4] ) end
			if debug then print ("--> FXText:setColor(): CHANGED COLOR.") end
		end				
	end

	-- VECTOR FONT: SET FONT SIZE ------------------------------
	function Group:setFontSize(fontSize)
		self.fontSize = fontSize
		_DrawChars		(self)
	end

	-- VECTOR FONT: ADD DROP SHADOW ----------------------------
	function Group:addDropShadow ( offX, offY, alpha )
		if offX ~= self.shadowOffX or offY ~= self.shadowOffY or alpha ~= self.shadowAlpha then
			self.shadowOffX 	= offX  ~= nil and offX or 0
			self.shadowOffY 	= offY  ~= nil and offY or 0
			self.shadowAlpha 	= alpha ~= nil and alpha or 0
			_DrawChars 			(self) 
			if debug then print ("--> FXText:addDropShadow(): SHADOW ADDED.") end
		end
	end

	-- START / STOP MARQUEE ------------------------------------
	function Group:startMarquee(charsToShow, speed, startOffset)
		self:stopMarquee()
		self.originX  		= "LEFT"
		self.startLine 		= 1
		self.linesToShow 	= 1
		self.wrapWidth 		= 0
		self.marqueeSpeed	= speed
		
		self.marqueeText	= ""
		for i = 1, string.len(self.text) do if string.sub(self.text,i,i) ~= newLineChar then self.marqueeText = self.marqueeText..string.sub(self.text,i,i) end end
		self.text 			= string.sub(self.marqueeText,1,charsToShow)
		self:removeDeform()
		self:removeAnimation()
		self:removeInOutTransition()
		self.nextCharPos	= charsToShow + 1; if self.nextCharPos > string.len(self.marqueeText) then self.nextCharPos = 1 end
		
		if startOffset ~= nil then self[2].x = startOffset end

		if string.sub (self.text,1,1) == " " then 
			self.charW = Charsets[self.fontName].spaceWidth 
		elseif self.shadowOffX ~= 0 or self.shadowOffY ~= 0 then
			self.charW = self[2][1][1].width 
		else 
			self.charW = self[2][1].width 
		end

		self.endX 			= -(self.charW + self.charSpacing)

		self.MarqueeTimer		= timer.performWithDelay(1, _Marquee, 0 )
		self.MarqueeTimer.Target= self
		if debug then print ("--> FXText:startMarquee(): MARQUEE STARTED.") end
	end

	function Group:stopMarquee()
		if self.MarqueeTimer ~= nil then 
			self[2].x = 0
			self[2].y = 0
			timer.cancel(self.MarqueeTimer)
			self.MarqueeTimer.Target = nil
			self.MarqueeTimer 		 = nil
		end
	end

	-- SET VISIBLE LINES ---------------------------------------
	function Group:setVisibleLines(startLine, linesToShow)
		if startLine < 1 then startLine = 1 end
		self.startLine   = startLine
		self.linesToShow = linesToShow
		_DrawChars			(self)
	end

	-- ADD / REMOVE BACKGROUND ---------------------------------
	function Group:addBackground ( Img, marginX, marginY, alpha, offX, offY )
		self:removeBackground()
		self[1]:insert(Img)
		Img.xReference = -Img.width  / 2
		Img.yReference = -Img.height / 2
		Img.alpha	   = alpha   ~= nil and alpha   or 1.0
		Img.marginX    = marginX ~= nil and marginX or 0
		Img.marginY    = marginY ~= nil and marginY or 0
		Img.offX	   = offX 	 ~= nil and offX	or 0
		Img.offY	   = offY 	 ~= nil and offY	or 0
		_DrawChars 			(self) 
		if debug then print ("--> FXText:addBackground(): BACKGROUND ADDED.") end
	end

	function Group:removeBackground () if self[1][1] ~= nil then self[1][1]:removeSelf() end end

	-- APPLY DEFORMATION ---------------------------------------
	function Group:applyDeform(Properties)
		if Properties.type == nil then print("!!! FXText:applyDeform(): INVALID TYPE (nil)."); return end
		self.DeformEffect  = nil
		self.DeformEffect  = {}
		for name, value in pairs(Properties) do self.DeformEffect[name] = value end
		_DrawChars			(self)
		if debug then print ("--> FXText:applyDeform(): APPLIED DEFORMATION (TYPE: "..Properties.type..").") end
	end
	
	-- REMOVE DEFORMATION --------------------------------------
	function Group:removeDeform()
		self.DeformEffect  = nil
		_DrawChars			(self)
		if debug then print ("--> FXText:removeDeform(): REMOVED DEFORMATION.") end
	end
	
	-- APPLY A TRANSITION TO ALL CHARS -------------------------
	function Group:applyInOutTransition(Properties)
		if Properties == nil then print("!!! FXText:applyInOutTransition(): INVALID TYPE (nil)."); return end
		_RemoveInOutTransition(self)

		self.InOutEffect = {}
		for name, value in pairs(Properties) do self.InOutEffect[name] = value end
		
		-- COMPLETE LISTENER?	
		if self.InOutEffect.CompleteListener ~= nil then Runtime:addEventListener( "transitionComplete", self.InOutEffect.CompleteListener ) end
		-- START NOW?
		if self.InOutEffect.startNow then _StartInOutTransition(self) end

		if debug then print ("--> FXText:applyTransition(): APPLIED IN-OUT TRANSITION.") end
	end

	function Group:startInOutTransition()
		_StartInOutTransition(self)
		if debug then print ("--> FXText:startInOutTransition(): STARTED IN-OUT TRANSITION.") end
	end

	-- REMOVE IN-OUT TRANSITION? -------------------------------
	function Group:stopInOutTransition()
		_StopInOutTransition(self)
		if debug then print ("--> FXText:stopInOutTransition(): STOPPED IN-OUT TRANSITION.") end
	end

	function Group:removeInOutTransition()
		_RemoveInOutTransition(self)
		if debug then print ("--> FXText:removeInOutTransition(): REMOVED IN-OUT TRANSITION.") end
	end

	-- CHECK IF A TRANSITION IS RUNNING ------------------------
	function Group:transitionActive()
		if self[2] == nil then return false end
		if self.TransIn or self.TransOut or self[2][self[2].numChildren].TransIn or self[2][self[2].numChildren].TransOut or self[2][1].TransIn or self[2][1].TransOut then return true else return false end
	end

	-- APPLY ANIMATED EFFECT -----------------------------------
	function Group:applyAnimation(Properties)
		if Properties.interval == nil then Properties.interval = 1 end
		self:stopAnimation ()
		self.AnimEffect  = {}
		for name, value in pairs(Properties) do self.AnimEffect[name] = value end
		if self.AnimEffect.startNow then self:startAnimation() end
		if debug then print ("--> FXText:applyAnimation(): STARTED ANIMATION.") end
	end
	
	-- START ANIMATED EFFECT -----------------------------------
	function Group:startAnimation()
		if self.AnimEffect == nil then print("!!! FXText:startAnimation(): NO ANIMATION DEFINED. USE applyAnimation() FIRST."); return end
		self:stopAnimation ()

		if self.AnimEffect.charWise 	== true then
			for i = 1, self[2].numChildren do
				if self.AnimEffect.startAlpha ~= nil then Group[2][i].alpha = self.AnimEffect.startAlpha end
				self[2][i].origAlpha  	= self[2][i].alpha
				self[2][i].origXScale 	= self[2][i].xScale
				self[2][i].origYScale 	= self[2][i].yScale
				self[2][i].origRot		= self[2][i].rotation
				self[2][i].origX		= self[2][i].x
				self[2][i].origY		= self[2][i].y
			end
		else
			self.origAlpha1	= self.alpha
			if self.AnimEffect.startAlpha ~= nil then self.alpha = self.AnimEffect.startAlpha end
			self.origAlpha 	= self.alpha
			self.origXScale	= self.xScale
			self.origYScale	= self.yScale
			self.origRot	= self.rotation
			self.origX		= self.x
			self.origY		= self.y
		end

		self.AnimTimer		  	  = timer.performWithDelay(1, _Animate, 0 )
		self.AnimTimer.Target 	  = self
		if debug then print ("--> FXText:startAnimation(): STARTED ANIMATION.") end
	end
	
	-- REMOVE ANIMATED EFFECT ----------------------------------
	function Group:stopAnimation()
		if self.AnimTimer ~= nil then 
			timer.cancel(self.AnimTimer)
			self.AnimTimer.Target = nil
			self.AnimTimer 		  = nil

			if self.AnimEffect.charWise == true then
				for i = 1, self[2].numChildren do
					self[2][i].alpha 	= self[2][i].origAlpha 
					self[2][i].xScale 	= self[2][i].origXScale
					self[2][i].yScale 	= self[2][i].origYScale
					self[2][i].rotation = self[2][i].origRot	
					self[2][i].x 		= self[2][i].origX		
					self[2][i].y 		= self[2][i].origY		
				end
			else
				self.alpha 		= self.origAlpha1
				self.xScale 	= self.origXScale
				self.yScale 	= self.origYScale
				self.rotation 	= self.origRot
				self.x 			= self.origX	
				self.y 			= self.origY
			end

			if debug then print ("--> FXText:stopAnimation(): STOPPED ANIMATION.") end
		end
	end

	function Group:removeAnimation()
		self:stopAnimation()
		if self.AnimEffect ~= nil then
			for name, value in pairs(self.AnimEffect) do self.AnimEffect[name] = nil end
			self.AnimEffect = nil
			if debug then print ("--> FXText:removeAnimation(): REMOVED ANIMATION.") end
		end
	end

	-- ADD SCROLLBAR -------------------------------------------
	function Group:addScrollbar( Properties )

		if Properties.Button 		== nil then print ("!!! FXText:addScrollbar(): NO SCROLLBUTTON IMAGE SPECIFIED."); return end
		if Properties.autoHide		== nil then Properties.autoHide 	= true end
		if Properties.scaleButton	== nil then Properties.scaleButton 	= true end
		if Properties.xOffset		== nil then Properties.xOffset	 	= 20 end
		if Properties.startLine		~= nil then self.startLine 			= Properties.startLine end
		if Properties.linesToShow	~= nil then self.linesToShow		= Properties.linesToShow end
		self:removeScrollbar()
	
		local Group 	 = display.newGroup()
			  Group.name = "Scrollbar"
		
		self:insert(4, Group)

		-- SCROLLBAR FRAME
		if Properties.FrameTop then
			Group:insert(Properties.FrameTop)
			Properties.FrameTop.yReference	= -Properties.FrameTop.height/ 2
			Properties.FrameTop.x = 0
			Properties.FrameTop.y = 0
		end

		if Properties.Frame then
			Group:insert(Properties.Frame)
			Properties.Frame.yReference	= -Properties.Frame.height/ 2
		end

		if Properties.FrameBottom then
			Group:insert(Properties.FrameBottom)
			Properties.FrameBottom.yReference	= Properties.FrameBottom.height/ 2
		end

		-- SCROLLBUTTON
		ButtonGroup 	 = display.newGroup()
		ButtonGroup.name = "Scrollbutton"
		Group:insert(ButtonGroup)
		
		if Properties.ButtonTop then
			ButtonGroup:insert(Properties.ButtonTop)
			Properties.ButtonTop.yReference	= -Properties.ButtonTop.height/ 2
			Properties.ButtonTop.x = 0
			Properties.ButtonTop.y = 0
		end
		
		ButtonGroup:insert(Properties.Button)
		Properties.Button.oHeight	 = Properties.Button.height
		Properties.Button.yReference =-Properties.Button.height/ 2

		if Properties.ButtonBottom then
			ButtonGroup:insert(Properties.ButtonBottom)
			Properties.ButtonBottom.yReference	= -Properties.ButtonBottom.height/ 2
		end
		
		ButtonGroup:addEventListener( "touch", _ScrollbarTouched )

		self.Scrollbar 		= Group
		self.ScrollButton 	= ButtonGroup
		for name, value in pairs(Properties) do self.Scrollbar[name] = value end
		_DrawChars			(self)

		if debug then print ("--> TextFX.addScrollbar(): SCROLLBAR ADDED.") end
	end

	-- REMOVE SCROLLBAR ----------------------------------------
	function Group:removeScrollbar( )
		if self.Scrollbar 	   ~= nil then
			self.ScrollButton:removeEventListener( "touch", _ScrollbarTouched )
			for name, value in pairs(Properties) do self.Scrollbar[name] = nil end
			self.Scrollbar:removeSelf()
			self.Scrollbar 		= nil
			self.ScrollButton 	= nil
			_DrawChars			(self)
		if debug then print ("--> TextFX.removeScrollbar(): SCROLLBAR REMOVED.") end
		end
	end

	-- HIDE SCROLLBAR ------------------------------------------
	function Group:hideScrollbar( ) if self.Scrollbar ~= nil then self.Scrollbar.isVisible = false end end

	-- SHOW SCROLLBAR ------------------------------------------
	function Group:showScrollbar( ) if self.Scrollbar ~= nil then self.Scrollbar.isVisible = true end end

	-- DELETE SELF ---------------------------------------------
	function Group:delete() DeleteText(self) end


	-- DRAW THE CHARS
	_ApplyProperties 	(Group, Properties)
	_DrawChars			(Group)

	if debug then print ("--> TextFX.CreateText(): TEXT CREATED.") end

	return Group
end

----------------------------------------------------------------
-- PRIVATE: SCROLLBAR FUNCTIONALITY
----------------------------------------------------------------
_ScrollbarTouched = function(event)

	local Obj  		  = event.target
	local Text 		  = Obj.parent.parent
	local linesToShow = Text.linesToShow ~= 0 and Text.linesToShow or #Text.wrappedLines
	local scroll, line, oldLine

	-- START DRAG?
	if event.phase == "began" then
		Obj.offY = event.y - Obj.y
		Obj.drag = true
		display.getCurrentStage():setFocus( Obj )

	-- DRAGGING?
	elseif Obj.drag == true then
		if event.phase == "moved" then
			y = event.y - Obj.offY
			if y < 0 then y = 0 elseif y > Obj.parent.height - Obj.height then y = Obj.parent.height - Obj.height end
			Obj.y = y
			
			oldLine = Text.startLine
			scroll  = Obj.y / (Obj.parent.height - Obj.height) -- 0.0 - 1.0
			line    = Floor(scroll * Text.maxScroll)
			if line < 1 then line = 1 elseif line > Text.maxScroll then line = Text.maxScroll end
			if line ~= oldLine then Text:setVisibleLines(line, linesToShow) end
			
		-- END DRAG?
		elseif event.phase == "ended" or event.phase == "cancelled" then
			display.getCurrentStage():setFocus( nil )
			Obj.drag = false
		end
	end

	return true
end

----------------------------------------------------------------
-- DELETE A TEXT OBJECT
----------------------------------------------------------------
function DeleteText(Group)
	if Group.name ~= "FXText" then print("!!! TextFX.DeleteText(): THIS IS NOT A TEXT FX OBJECT."); return end
	local i

	-- STOP MARQUEE
	Group:stopMarquee()

	-- REMOVE SCROLLBAR
	Group:removeScrollbar()

	-- REMOVE ANIMATIONS
	Group:removeAnimation()

	-- REMOVE BACKGROUND
	Group:removeBackground()

	-- REMOVE IN-OUT TRANSITION
	_RemoveInOutTransition(Group)
	
	-- DELETE CHARS
	while Group[2].numChildren > 0 do Group[2][1]:removeSelf() end
	
	-- REMOVE FROM LIST
	for i, Object in ipairs(ObjectList) do
		if Object == Group then table.remove(ObjectList, i); break end
	end				
	-- CLEAN UP
	Group.wrappedLines 			= nil
	Group.lineWidths   			= nil
	Group.DeformEffect			= nil
	Group.setText 				= nil
	Group.getText 				= nil
	Group.getNumLines 			= nil
	Group.getLine				= nil
	Group.getLineWidth			= nil
	Group.setOrigin				= nil
	Group.setTexFlow			= nil
	Group.setProperties			= nil
	Group.setProperty			= nil
	Group.applyDeform   		= nil
	Group.removeDeform  		= nil
	Group.stopInOutTransition	= nil
	Group.startInOutTransition	= nil
	Group.applyInOutTransition	= nil
	Group.removeInOutTransition	= nil
	Group.startAnimation		= nil
	Group.stopAnimation			= nil
	Group.startMarquee			= nil
	Group.stopMarquee			= nil
	Group.setScroll				= nil
	Group.getScroll				= nil
	Group.scroll				= nil
	Group.addBackground			= nil
	Group.removeBackground		= nil
	Group.setColor				= nil
	Group.delete				= nil
	Group:removeSelf()
	Group = nil
	if debug then print ("--> TextFX.DeleteText(): TEXT DELETED. REMAINING TEXTS: "..#ObjectList) end
end

----------------------------------------------------------------
-- DELETE ALL TEXT OBJECTS
----------------------------------------------------------------
function DeleteTexts()

	if debug then print ("\n\n--> TextFX.DeleteTexts(): DELETING ALL TEXTS...") end
	while(#ObjectList) > 0 do DeleteText(ObjectList[1]) end
	if debug then print ("--> TextFX.DeleteTexts(): DONE.\n\n") end

end

----------------------------------------------------------------
-- CALCUALTE WIDTH OF A TEXT LINE
----------------------------------------------------------------
function GetLineWidth(fontName, txt, charSpacing)
	local Charset = Charsets[fontName]; if Charset == nil then print("!!! TextFX.GetLineWidth(): CHARSET "..fontName.." NOT FOUND."); return end
	local i, c, Char
	local l = string.len(txt)
	local w = 0

	if charSpacing == nil then charSpacing = 0 end

	-- LOOP TEXT
	for i = 1, l do
		c    = string.sub (txt,i,i)
		Char = Charset.Chars[ string.byte(c) ]
		if Char == nil then 
			print("!!! TextFX.GetLineWidth(): CHAR '"..c.."' NOT INCLUDED IN CHARSET '"..fontName.."'!")
		elseif c ~= newLineChar then
			w = w + Char.width; if i < string.len(txt) then w = w + charSpacing end
		else 
			break
		end
	end
	return w
end









----------------------------------------------------------------
-- PRIVATE FUNCTIONS
----------------------------------------------------------------





----------------------------------------------------------------
-- PRIVATE: START AN APPLIED IN-OUT TRANSITION
----------------------------------------------------------------
_StartInOutTransition = function(Group)
	local Trans, c, delayStep
	local duration = 0

	if Group.InOutEffect ~= nil then
		if Group.InOutEffect.restoreOnComplete == true then
			Group.origVisible= Group.isVisible
			Group.origAlpha  = Group.alpha
			Group.origXScale = Group.xScale
			Group.origYScale = Group.yScale
			Group.origRot	 = Group.rotation
			Group.origX		 = Group.x
			Group.origY		 = Group.y
		end
	end

	_StopInOutTransition(Group)
	

	----------------
	-- IN-TRANSITION
	----------------
	if Group.InOutEffect.AnimateFrom ~= nil then
		Trans = Group.InOutEffect.AnimateFrom

		if Group.InOutEffect.inMode == "RANDOM" then
			Trans.delay 	= Group.InOutEffect.inDelay + Ceil(Rnd()* ((Group[2].numChildren) * Group.InOutEffect.inCharDelay) - Group.InOutEffect.inCharDelay )
			delayStep		= 0
		elseif Group.InOutEffect.inMode == "LEFT_RIGHT" then
			Trans.delay 	= Group.InOutEffect.inDelay
			delayStep		= Group.InOutEffect.inCharDelay
		elseif Group.InOutEffect.inMode == "RIGHT_LEFT" then
			Trans.delay 	= Group.InOutEffect.inDelay + ((Group[2].numChildren) * Group.InOutEffect.inCharDelay) - Group.InOutEffect.inCharDelay
			delayStep		=-Group.InOutEffect.inCharDelay
		else -- "ALL"
			Trans.delay 	= Group.InOutEffect.inDelay
		end

		if Group.InOutEffect.inMode == "ALL" then
				Group.isVisible = not Group.InOutEffect.hideCharsBefore
				Trans.onStart   = function() Group.isVisible = true; if Group.InOutEffect.InSound ~= nil then audio.play( Group.InOutEffect.InSound, { channel = 0, loop = 0 } ) end end
				Trans.onComplete= function() Group.TransIn = nil end
				Group.TransIn	= transition.from (Group, Trans )
				duration 		= Group.InOutEffect.inDelay + Trans.time
		else
			for c = 1, Group[2].numChildren do
				Group[2][c].isVisible 	= not Group.InOutEffect.hideCharsBefore
				Trans.onStart     	= function() Group[2][c].isVisible = true; if Group.InOutEffect.InSound ~= nil then audio.play( Group.InOutEffect.InSound, { channel = 0, loop = 0 } ) end end
				Trans.onComplete	= function() Group[2][c].TransIn   = nil end
				Group[2][c].TransIn	= transition.from (Group[2][c], Trans )

				if Group.InOutEffect.inMode == "RANDOM" then
					Trans.delay = Group.InOutEffect.inDelay + Ceil(Rnd()* ((Group[2].numChildren) * Group.InOutEffect.inCharDelay) - Group.InOutEffect.inCharDelay )
				else
					Trans.delay = Trans.delay + delayStep
				end
			end
			duration = Group.InOutEffect.inDelay + (Group[2].numChildren)*Group.InOutEffect.inCharDelay + Trans.time
		end
	end

	-----------------
	-- OUT-TRANSITION
	-----------------
	if Group.InOutEffect.AnimateTo ~= nil then
		Trans = Group.InOutEffect.AnimateTo

		if Group.InOutEffect.outMode == "RANDOM" then
			Trans.delay 	= duration + Group.InOutEffect.outDelay + (Group[2].numChildren * Group.InOutEffect.outCharDelay + Trans.time) 
			delayStep		= 0
		elseif Group.InOutEffect.outMode == "LEFT_RIGHT" then
			Trans.delay 	= duration + Group.InOutEffect.outDelay
			delayStep		= Group.InOutEffect.outCharDelay
		elseif Group.InOutEffect.outMode == "RIGHT_LEFT" then
			Trans.delay 	= duration + Group.InOutEffect.outDelay + ((Group[2].numChildren) * Group.InOutEffect.outCharDelay) - Group.InOutEffect.outCharDelay
			delayStep		=-Group.InOutEffect.outCharDelay
		else -- "ALL"
			Trans.delay 	= duration + Group.InOutEffect.outDelay
		end

		if Group.InOutEffect.outMode == "ALL" then
			Trans.onStart 	 = function() if Group.InOutEffect.OutSound ~= nil then audio.play( Group.InOutEffect.OutSound, { channel = 0, loop = 0 } ) end end
			Trans.onComplete = function() Group.TransOut = nil; Group.isVisible = not Group.InOutEffect.hideCharsAfter end
			Group.TransOut   = transition.to (Group, Trans )
			duration 		 = Trans.delay + Trans.time --Group.InOutEffect.outDelay + Trans.time
		else
			for c = 1, Group[2].numChildren do
				Trans.onStart 	  = function() if Group.InOutEffect.OutSound ~= nil then audio.play( Group.InOutEffect.OutSound, { channel = 0, loop = 0 } ) end end
				Trans.onComplete  = function() Group[2][c].TransOut = nil; Group[2][c].isVisible = not Group.InOutEffect.hideCharsAfter end
				Group[2][c].TransOut = transition.to (Group[2][c], Trans )

				if Group.InOutEffect.outMode == "RANDOM" then
					Trans.delay = duration + Group.InOutEffect.outDelay + Ceil(Rnd()* ((Group[2].numChildren) * Group.InOutEffect.outCharDelay) - Group.InOutEffect.outCharDelay )
				else
					Trans.delay = Trans.delay + delayStep
				end
			end
			duration = duration + Group.InOutEffect.outDelay + (Group[2].numChildren)*Group.InOutEffect.outCharDelay + Trans.time
		end
	end

	-----------------------------------------
	-- AUTO-REMOVE / LOOP / COMPLETE LISTENER
	-----------------------------------------
	if Group.InOutEffect.autoRemoveText == true then 
		Group.InOutTimer = timer.performWithDelay(duration, function() if Group.InOutEffect.CompleteListener ~= nil then local event = { name = "transitionComplete", target = Group } Runtime:dispatchEvent(event) end Group:delete() end ) 
	elseif Group.InOutEffect.loop == true then 
		Group.InOutTimer = timer.performWithDelay(duration, function() if Group.InOutEffect.CompleteListener ~= nil then local event = { name = "transitionComplete", target = Group } Runtime:dispatchEvent(event) end _DrawChars(Group); if Group.InOutEffect.restartOnChange == false then _StartInOutTransition(Group) end end )
	else
		Group.InOutTimer = timer.performWithDelay(duration, function() if Group.InOutEffect.CompleteListener ~= nil then local event = { name = "transitionComplete", target = Group } Runtime:dispatchEvent(event) end end )
	end
end

----------------------------------------------------------------
-- PRIVATE: STOP AN APPLIED IN-OUT TRANSITION
----------------------------------------------------------------
_StopInOutTransition = function(Group)

	local name, value

	-- IF TRANSITION STILL RUNNING, SET OBJECT TO TRANSITION END VALUES
	if Group.TransIn  ~= nil then 
		transition.cancel(Group.TransIn );
		if Group.TransIn._keysFinish ~= nil then
			for name,value in pairs(Group.TransIn._keysFinish) do Group[name] = value end
		end
		Group.TransIn = nil
	end

	if Group.TransOut  ~= nil then 
		transition.cancel(Group.TransOut );
		if Group.TransOut._keysFinish ~= nil then
			for name,value in pairs(Group.TransOut._keysFinish) do Group[name] = value end
		end
		Group.TransOut = nil
	end

	if Group.InOutEffect ~= nil then
		if Group.InOutEffect.restoreOnComplete == true then
			if Group.origVisible~= nil then Group.isVisible = Group.origVisible end
			if Group.origAlpha  ~= nil then Group.alpha		= Group.origAlpha  end
			if Group.origXScale ~= nil then Group.xScale	= Group.origXScale end
			if Group.origYScale ~= nil then Group.yScale	= Group.origYScale end
			if Group.origRot	~= nil then Group.rotation	= Group.origRot	   end
			if Group.origX		~= nil then Group.x			= Group.origX	   end
			if Group.origY		~= nil then Group.y			= Group.origY	   end
		end
	end
	
	-- NO NEED TO SET CHARS TO TRANSITION END VALUES (THEY'RE DELETED ON REDRAW ANYWAY)
	local i
	for i = 1, Group[2].numChildren do 
		if Group[2][i].TransIn  ~= nil then transition.cancel(Group[2][i].TransIn ); Group[2][i].TransIn  = nil end
		if Group[2][i].TransOut ~= nil then transition.cancel(Group[2][i].TransOut); Group[2][i].TransOut = nil end
	end

	if Group.InOutTimer ~= nil then timer.cancel(Group.InOutTimer); Group.InOutTimer = nil end
end

----------------------------------------------------------------
-- PRIVATE: DELETE AN APPLIED IN-OUT TRANSITION
----------------------------------------------------------------
_RemoveInOutTransition = function(Group)
	_StopInOutTransition(Group)

	local name, value

	if Group.InOutEffect ~= nil then
		if Group.InOutEffect.CompleteListener ~= nil then
			Runtime:removeEventListener("transitionComplete", Group.InOutEffect.CompleteListener)
		end

		for name, value in pairs(Group.InOutEffect) do Group.InOutEffect[name] = nil end
		Group.InOutEffect = nil
	end
end

----------------------------------------------------------------
-- PRIVATE: VERIFY PROPERTIES, APPLY THEM TO TEXT OBJECT
----------------------------------------------------------------
_ApplyProperties = function(Group, Properties)

	local oldText = Group.text

	local Charset = Charsets[Properties.fontName]
	if Charset.charSpacing ~= nil then Group.charSpacing = Charset.charSpacing end
	if Charset.lineSpacing ~= nil then Group.lineSpacing = Charset.lineSpacing end

	-- SET PROPERTIES
	if Properties.fontName 		~= nil then Group.fontName		= Properties.fontName end
	if Properties.text     		~= nil then Group.text		    = Properties.text end
	if Properties.originX  		~= nil then Group.originX	    = string.upper(Properties.originX) end
	if Properties.originY  		~= nil then Group.originY	    = string.upper(Properties.originY) end
	if Properties.textFlow 		~= nil then Group.textFlow		= string.upper(Properties.textFlow) end
	if Properties.wrapWidth		~= nil then Group.wrapWidth		= Properties.wrapWidth end
	if Properties.charSpacing 	~= nil then Group.charSpacing 	= Properties.charSpacing end
	if Properties.lineSpacing	~= nil then Group.lineSpacing 	= Properties.lineSpacing end
	if Properties.showOrigin	~= nil then Group.showOrigin	= Properties.showOrigin end
	if Properties.x 			~= nil then Group.x = Properties.x end
	if Properties.y 			~= nil then Group.y = Properties.y end
	if Properties.startLine		~= nil then Group.startLine 	= Properties.startLine end
	if Properties.linesToShow	~= nil then Group.linesToShow	= Properties.linesToShow end
	if Properties.Color			~= nil then Group.Color			= Properties.Color end
	if Properties.fontSize		~= nil then Group.fontSize		= Properties.fontSize end
	if Properties.shadowOffX	~= nil then Group.shadowOffX	= Properties.shadowOffX end
	if Properties.shadowOffY	~= nil then Group.shadowOffY	= Properties.shadowOffY end
	if Properties.shadowAlpha	~= nil then Group.shadowAlpha	= Properties.shadowAlpha end

	-- DEFAULTS
	if Group.text	 			== nil then Group.text	 		= "" end
	if Group.originX			== nil then Group.originX 		= "CENTER" end
	if Group.originY			== nil then Group.originY 		= "CENTER"	 end
	if Group.textFlow			== nil then Group.textFlow 		= "LEFT" end	
	if Group.wrapWidth			== nil then Group.wrapWidth 	= 0	 end
	if Group.showOrigin			== nil then Group.showOrigin 	= false	 end
	if Group.startLine			== nil then Group.startLine 	= 1	 end
	if Group.linesToShow		== nil then Group.linesToShow 	= 0	 end
	if Group.Color				== nil then Group.Color			= {255,255,255,255} end
	if Group.Color[1]			== nil then Group.Color[1]		= 255 end
	if Group.Color[2]			== nil then Group.Color[2]		= 255 end
	if Group.Color[3]			== nil then Group.Color[3]		= 255 end
	if Group.Color[4]			== nil then Group.Color[4]		= 255 end
	if Group.fontSize			== nil then Group.fontSize	    = Charsets[Group.fontName].fontSize end
	if Group.shadowOffX			== nil then Group.shadowOffX    = 0 end
	if Group.shadowOffY			== nil then Group.shadowOffY    = 0 end
	if Group.shadowAlpha		== nil then Group.shadowAlpha   = 128 end
	if Group.charSpacing		== nil then Group.charSpacing 	= 0	 end
	if Group.lineSpacing		== nil then Group.lineSpacing 	= 0	 end
end

----------------------------------------------------------------
-- PRIVATE: DRAW THE CHARS OF A TEXT OBJECT
----------------------------------------------------------------
_DrawChars = function(Group)
	
	if Group.name ~= "FXText" then print("!!! TextFX._DrawChars(): THIS IS NOT A TEXT FX OBJECT."); return end
	
	local Charset = Charsets[Group.fontName]; if Charset == nil then print("!!! TextFX._DrawChars(): CHARSET "..Group.fontName.." NOT FOUND."); return end
	local c, n, i, j, Img, len, x, y, yy, Char, Temp, spaceBefore
	local ox = 0
	local oy = 0

	-- REMOVE ANIMATIONS
	Group:stopAnimation()

	-- STOP IN-OUT TRANSITION
	_StopInOutTransition (Group)

	-- DELETE CHARS
	while Group[2].numChildren > 0 do Group[2][1]:removeSelf() end

	-- WRAP TEXT LINES
	_SetWrappedTextData (Group)

	-- ORIGIN
	    if Group.originX == "CENTER" then ox = -Group.maxLineWidth*.5 
	elseif Group.originX == "RIGHT"  then ox = -Group.maxLineWidth end
	    if Group.originY == "CENTER" then oy = -Group.totalHeight*.5
	elseif Group.originY == "BOTTOM" then oy = -Group.totalHeight end

	-- LOOP LINES, CREATE CHARS
	local linesDrawn = 0
	for j = Group.startLine, Group.endLine do
		len 		= string.len( Group.wrappedLines[j] )
		linesDrawn 	= linesDrawn + 1
		y   		= oy + (linesDrawn-1) * (Charset.lineHeight + Group.lineSpacing)
		x   		= ox
		
		-- TEXT FLOW
		    if Group.textFlow == "CENTER" then x = x + (Group.maxLineWidth - Group.lineWidths[j]) * .5 
		elseif Group.textFlow == "RIGHT"  then x = x + (Group.maxLineWidth - Group.lineWidths[j]) end

		-- EMPTY LINE? - CREATE PLACEHOLDER
		if Group.wrappedLines[j] == "" then
			Img   = display.newGroup()
			Img.x = x
			Img.y = y
			Group[2]:insert(Img)
		end

		for i = 1, len do
			c    = string.sub (Group.wrappedLines[j],i,i)
			n    = string.byte(c)
			Char = Charset.Chars[n]

			if Char == nil then print("!!! TextFX._DrawChars(): CHAR '"..c.."' NOT INCLUDED IN CHARSET '"..Group.fontName.."'!")
			else
				-- IS NEW LINE
				if n ~= 32 then
					if Charset.isVector then
						if Group.shadowOffX ~= 0 or Group.shadowOffY ~= 0 then
							yy   = -Char.height*.5
							Img  = display.newGroup()
							Temp = display.newText( c, Group.shadowOffX, yy + Group.shadowOffY, Charset.name, Group.fontSize * Charset.scale )
							Temp:setTextColor( 0,0,0, Group.shadowAlpha )
							Img:insert(Temp)
							Temp = display.newText( c, 0, yy, Charset.name, Group.fontSize * Charset.scale )
							Temp:setTextColor( Group.Color[1],Group.Color[2],Group.Color[3],Group.Color[4] )
							Img:insert(Temp)
						else
							Img = display.newText( c, 0, 0, Charset.name, Group.fontSize * Charset.scale )
							Img:setTextColor( Group.Color[1],Group.Color[2],Group.Color[3],Group.Color[4] )
						end
					else
						Img = sprite.newSprite(Charset.Set)
						Img.currentFrame = Char.frame
					end
					Img.name		 = "FXChar"
					Img.index		 = i
					Img.char		 = c
					Img.charNum		 = n
					Img.spaceBefore  = spaceBefore
					Img.yReference	 = -Char.offY
					Img.xScale		 = Charset.scale
					Img.yScale		 = Charset.scale
					Img.x			 = x + (Char.width*.5)
					Img.y			 = y + Char.height*.5
					Group[2]:insert(Img)
					spaceBefore 	 = false
				else
					spaceBefore 	 = true
				end
				x = x + Char.width + Group.charSpacing
			end
		end -- /LOOP THIS LINE
	
	end -- /LOOP LINES

    -- HIDE / SHOW ORIGIN
    Group[3].isVisible	= Group.showOrigin == true and true or false
    
    -- ADJUST BACKGROUND
    if Group[1][1] ~= nil then
    	local BG = Group[1][1]
		x, y = Group[2]:contentToLocal(Group[2].contentBounds.xMin - BG.marginX, Group[2].contentBounds.yMin - BG.marginY)
		BG.x	  = x + BG.offX
		BG.y	  = y + BG.offY
		BG.yScale = (Group[2].height + BG.marginY*2) / BG.height
		if Group.Scrollbar ~= nil then
			BG.xScale = (Group.maxLineWidth + BG.marginX + Group.Scrollbar.width + Group.Scrollbar.xOffset) / BG.width
		else
			BG.xScale = (Group.maxLineWidth + BG.marginX*2) / BG.width
		end
	end
    
    -- ADJUST SCROLLBAR
    if Group.Scrollbar ~= nil then
    	local Scrollbar = Group.Scrollbar

	    -- HIDE / SHOW SCROLLBAR?
		if Scrollbar.autoHide == true and (#Group.wrappedLines <= Group.linesToShow) or (Group.linesToShow == 0) then Scrollbar.isVisible = false else Scrollbar.isVisible = true end

		-- ADJUST SCROLLBAR	HEIGHT 
		local h = Group[2].height
		Scrollbar.x, Scrollbar.y = Group[2]:contentToLocal(Group[2].contentBounds.xMin + (Group.maxLineWidth + Scrollbar.xOffset)*Group.xScale, Group[2].contentBounds.yMin)

		if Scrollbar.Frame then
			Scrollbar.Frame.x = 0
			Scrollbar.Frame.y = 0
			if Scrollbar.FrameBottom then h = h - Scrollbar.FrameBottom.height end
			if Scrollbar.FrameTop    then h = h - Scrollbar.FrameTop.height; Scrollbar.Frame.y = Scrollbar.FrameTop.height end
			Scrollbar.Frame.yScale = h / Scrollbar.Frame.height
		end

		if Scrollbar.FrameBottom then
			Scrollbar.FrameBottom.x = 0
			Scrollbar.FrameBottom.y = Group[2].height
		end

		Scrollbar.Button.x = 0
		Scrollbar.Button.y = 0
		if Scrollbar.ButtonTop then Scrollbar.Button.y = Scrollbar.ButtonTop.height end

		h = Scrollbar.Button.oHeight
		if Scrollbar.scaleButton == true then
			h = Group[2].height * (Group.linesToShow / #Group.wrappedLines)
			if Scrollbar.ButtonBottom then h = h - Scrollbar.ButtonBottom.height end
			if Scrollbar.ButtonTop	  then h = h - Scrollbar.ButtonTop.height; Scrollbar.Button.y = Scrollbar.ButtonTop.height end
			Scrollbar.Button.yScale = h / Scrollbar.Button.oHeight
		end

		if Scrollbar.ButtonBottom then
			Scrollbar.ButtonBottom.x = 0
			Scrollbar.ButtonBottom.y = Scrollbar.Button.y + h
		end
	end

	-- RENDER APPLIED DEFORMATIONS?
	if Group.DeformEffect ~= nil then _DoDeform (Group) end

	-- AUTO-APPLY IN-OUT EFFECT?
	if Group.InOutEffect ~= nil and Group.InOutEffect.restartOnChange == true then 
		_StartInOutTransition(Group) 
	end

	-- AUTO-APPLY ANIMATION?
	if Group.AnimEffect ~= nil and Group.AnimEffect.restartOnChange == true then
		Group:startAnimation()
	end

end

----------------------------------------------------------------
-- PRIVATE: RENDER DEFORMATION APPLIED TO A SPECIFIED TEXT
----------------------------------------------------------------
_DoDeform = function(Group)
	local i, n, j, v1, v2, v3
	
	local Deform = Group.DeformEffect
	
	--------------------------------------------------------
	if Deform.type == DEFORM_SHAKE then
		Seed(1)
		for j = 1, Group[2].numChildren do
			v1 = -(Deform.scaleVariation*.5) + Rnd()*Deform.scaleVariation
			Group[2][j].rotation = Group[2][j].rotation - (Deform.angleVariation*.5) + Rnd()*Deform.angleVariation
			Group[2][j].xScale   = Group[2][j].xScale + v1
			Group[2][j].yScale   = Group[2][j].yScale + v1
			Group[2][j].x		 = Group[2][j].x -(Deform.xVariation*.5) + Rnd()*Deform.xVariation
			Group[2][j].y		 = Group[2][j].y -(Deform.yVariation*.5) + Rnd()*Deform.yVariation
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_WAVE_Y then
		for j = 1, Group[2].numChildren do
			Group[2][j].y = Group[2][j].y + Sin(Group[2][j].x / Deform.frequency) * (Deform.amplitude)
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_WAVE_SCALE then
		for j = 1, Group[2].numChildren do
			v1 = Deform.minScale + (Sin(Group[2][j].x / Deform.frequency) * (Deform.amplitude))
			if Deform.scaleX then Group[2][j].xScale = Group[2][j].xScale + v1 end
			if Deform.scaleY then Group[2][j].yScale = Group[2][j].yScale + v1 end
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_MIRROR then
		for j = 1, Group[2].numChildren do
			if Deform.mirrorX then Group[2][j].xScale = Group[2][j].xScale * -1 end
			if Deform.mirrorY then Group[2][j].yScale = Group[2][j].yScale * -1 end
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_ZIGZAG then
		for j = 1, Group[2].numChildren do
			if Mod(j,2) == 0 then
				Group[2][j].y		 = Group[2][j].y		  - Deform.toggleY
				Group[2][j].rotation = Group[2][j].rotation - Deform.toggleAngle
				Group[2][j].xScale	 = Group[2][j].xScale	  - Deform.toggleScale
				Group[2][j].yScale	 = Group[2][j].yScale	  - Deform.toggleScale
			else
				Group[2][j].y		 = Group[2][j].y 		  + Deform.toggleY
				Group[2][j].rotation = Group[2][j].rotation + Deform.toggleAngle
				Group[2][j].xScale	 = Group[2][j].xScale	  + Deform.toggleScale
				Group[2][j].yScale	 = Group[2][j].yScale	  + Deform.toggleScale
			end
			if Deform.minScale ~= nil then
				if Group[2][j].xScale < Deform.minScale then Group[2][j].xScale = Deform.minScale end
				if Group[2][j].yScale < Deform.minScale then Group[2][j].yScale = Deform.minScale end
			end
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_SQUEEZE then
		local Charset = Charsets[Group.fontName]
		local Char, x, percent
		local minX = 0
		local maxX = 0
		for j = 1, Group[2].numChildren do 
				if Group[2][j].x < minX then minX = Group[2][j].x end
				if Group[2][j].x > maxX then maxX = Group[2][j].x end
		end
		local width = Group.maxLineWidth; if minX < 0 then width = maxX - minX end

		for j = 1, Group[2].numChildren do
			x 		= Group[2][j].x; if minX < 0 then x = x - minX end
			percent = x / width
			Char 	= Charset.Chars[Group[2][j].charNum]

			if Deform.mode == "INNER" then
				if percent <= 0.5 then
					v1 = Deform.min + Cos(2.0*(percent)^.3) * Deform.max 
				else
					v1 = Deform.min + Cos(2.0*(1.0-percent)^.3) * Deform.max 
				end
				if Deform.scaleX then Group[2][j].xScale = Group[2][j].xScale + v1 end
				if Deform.scaleY then Group[2][j].yScale = Group[2][j].yScale + v1 end

			elseif Deform.mode == "OUTER" then
				if percent <= 0.5 then
					v1 = Deform.min + Sin(2.0*(percent)^0.65) * Deform.max 
				else
					v1 = Deform.min + Sin(2.0*(1.0-percent)^0.65) * Deform.max 
				end
				if Deform.scaleX then Group[2][j].xScale = Group[2][j].xScale + v1 end
				if Deform.scaleY then Group[2][j].yScale = Group[2][j].yScale + v1 end

			elseif Deform.mode == "LEFT" then
				if Deform.scaleX then Group[2][j].xScale = Group[2][j].xScale + (Deform.min + percent * Deform.max) end
				if Deform.scaleY then Group[2][j].yScale = Group[2][j].yScale + (Deform.min + percent * Deform.max) end

			elseif Deform.mode == "RIGHT" then
				if Deform.scaleX then Group[2][j].xScale = Group[2][j].xScale + (Deform.min + (1.0-percent) * Deform.max) end
				if Deform.scaleY then Group[2][j].yScale = Group[2][j].yScale + (Deform.min + (1.0-percent) * Deform.max) end
			end
			--print(percent.."%  "..Group[2][j].yScale)
		end
	--------------------------------------------------------
	elseif Deform.type == DEFORM_CIRCLE then
		if Group[2].numChildren == 0 then return end
		local Char, a, c, step, offY 
		local Charset = Charsets[Group.fontName]
		local childs  = Group[2].numChildren 
		local radius  = Deform.radius
		local angle   = 0

		if Deform.autoStep == true then step = 360.0 / string.len(Group.text) else step = Deform.angleStep end

		for j = 1, childs do
			if Group[2][j].spaceBefore == true and Deform.ignoreSpaces ~= true then angle = angle + step end

			a = Rad(angle-90)  
			if Group[2][j].char ~= " " and Group[2][j].char ~= newLineChar then
				offY = 0; Char = Charset.Chars[Group[2][j].charNum]; if Char ~= nil then offY = Char.offY end
				if offY > 0 then
					Group[2][j].x = Cos(a) * (radius - offY * -.5)
					Group[2][j].y = Sin(a) * (radius - offY * -.5)
				else
					Group[2][j].x = Cos(a) * (radius - offY * 2.0)
					Group[2][j].y = Sin(a) * (radius - offY * 2.0)
				end
				Group[2][j].rotation = angle
			end
			angle  = angle  + step
			if Deform.radiusChange ~= nil then radius = radius + Deform.radiusChange end
			if Deform.stepChange   ~= nil then step   = step   + Deform.stepChange end
		end
	--------------------------------------------------------

	if debug then print("--> TextFX: PROCESSED DEFORMATION (TYPE: "..Deform.type..")") end
	end --/SWITCH DEFORM NAME
end

----------------------------------------------------------------
-- PRIVATE: SET WRAPPED TEXT LINE DATA ON A TEXT OBJECT
----------------------------------------------------------------
_SetWrappedTextData = function(Group)
	local fontName 		= Group.fontName
	local wrapWidth		= Group.wrapWidth
	local charSpacing 	= Group.charSpacing
	local txt			= Group.text
	local Charset  		= Charsets[fontName]; if Charset == nil then print("!!! TextFX: CHARSET "..fontName.." NOT FOUND."); return 0 end
	local ln			= 1 	-- CURRENT LINE NUMBER			
	local cl			= ""	-- CURRENT LINE TEXT
	local c, n, cc, cw, i, j, len1, len2

	-- DISCARD OLD WRAPPED DATA
	Group.wrappedLines = nil; Group.wrappedLines = {}
	Group.lineWidths   = nil; Group.lineWidths   = {}
	Group.maxLineWidth	= 0
	
	-- REMOVE NEW LINES AT BEGINNING
	i = 1; while string.sub(txt,i,i) == newLineChar do i = i + 1 end; txt = string.sub(txt,i)

	-- WRAP TEXT
	len1= string.len(txt)
	for i = 1, len1 do
		c = string.sub(txt,i,i)

			cw = GetLineWidth(fontName, cl, charSpacing)

			-- NEW LINE CHAR?
			if c == newLineChar then 
				Group.wrappedLines[ln] = cl
				Group.lineWidths  [ln] = cw
				cl = ""
				ln = ln + 1

			else cl = cl..c end
			
			-- LENGTH EXCEEDED? WRAP TO NEW LINE
			if wrapWidth > 0 and cw > wrapWidth then
				len2 = string.len(cl)
				for j = len2, 1, -1 do
					cc = string.sub (cl,j,j)
					n  = string.byte(cc)
					
					if n == 32 then
						Group.wrappedLines[ln] = string.sub(cl,1,j-1)
						Group.lineWidths  [ln] = GetLineWidth(fontName, Group.wrappedLines[ln], charSpacing)
						cl = string.sub(cl,j+1)
						ln = ln + 1

					elseif cc == "-" then
						Group.wrappedLines[ln] = string.sub(cl,1,j)
						Group.lineWidths  [ln] = GetLineWidth(fontName, Group.wrappedLines[ln], charSpacing)
						cl = string.sub(cl,j+1)
						ln = ln + 1
					end
				
				end -- /REWIND
			end -- /IF MAXWIDTH EXCEEDED?
	end -- /LOOP STRING

	Group.wrappedLines[ln] = cl
	Group.lineWidths  [ln] = GetLineWidth(fontName, Group.wrappedLines[ln], charSpacing)

	-- FIND MAX LINE WIDTH
	for i = 1, #Group.wrappedLines do
		if Group.lineWidths[i] > Group.maxLineWidth then Group.maxLineWidth = Group.lineWidths[i] end
		--print("LINE "..i.." = '"..Group.wrappedLines[i].."'    WIDTH = "..Group.lineWidths[i] )
	end

	-- START LINE & VISIBLE LINES
	if Group.linesToShow == 0 then
		Group.maxScroll = 1
		if Group.startLine > #Group.wrappedLines then Group.startLine = #Group.wrappedLines end
		Group.endLine = #Group.wrappedLines
	else
		Group.maxScroll = #Group.wrappedLines - (Group.linesToShow-1)
		if Group.maxScroll < 1 then Group.maxScroll = 1 end
		if Group.startLine > Group.maxScroll then Group.startLine = Group.maxScroll end
		if Group.startLine < 1 then Group.startLine = 1 end
		Group.endLine = Group.startLine + (Group.linesToShow-1)
		if Group.endLine > #Group.wrappedLines then Group.endLine = #Group.wrappedLines end
	end
	local numLines = (Group.endLine - Group.startLine) + 1

	-- GET MAX HEIGHT
	Group.totalHeight = numLines * Charset.lineHeight + (numLines-1) * Group.lineSpacing

end

----------------------------------------------------------------
-- PRIVATE: PROCESS TEXT ANIMATION
----------------------------------------------------------------
_Animate = function(event)

	local Timer 	= event.source
	local Group 	= Timer.Target
	local FX    	= Group.AnimEffect
	local numChars 	= Group[2].numChildren
	local now		= GetTimer()
	local i, vSin, vCos, alpha
	
	-- JUST STARTED?
	if Timer._count < 3 then
		if FX.duration		  == nil then FX.duration = 0 end
		if FX.delay			  == nil then FX.delay	= 0 end
		if FX.charWise		  == nil then FX.charWise = true end

		Timer.startTime = now
		Timer.endTime   = now + FX.delay + FX.duration
	
	-- RUNNING?
	elseif now-Timer.startTime >= FX.delay then
		if FX.charWise == true then
			for i = 1, numChars do 
				vSin  = Sin(now / FX.frequency + i)
				vCos  = Cos(now / FX.frequency + i)
				if FX.alphaRange	~= nil then 
					alpha 				= Group[2][i].origAlpha  + vSin * FX.alphaRange; if alpha > 1.0 then alpha = 1.0 elseif alpha < 0 then alpha = 0 end
					Group[2][i].alpha	= alpha 
				end
				if FX.xScaleRange 	~= nil then Group[2][i].xScale 		= Group[2][i].origXScale + vSin * FX.xScaleRange end
				if FX.yScaleRange 	~= nil then Group[2][i].yScale 		= Group[2][i].origYScale + vSin * FX.yScaleRange end
				if FX.rotationRange	~= nil then Group[2][i].rotation 	= Group[2][i].origRot    + vSin * FX.rotationRange end
				if FX.xRange		~= nil then Group[2][i].x		 	= Group[2][i].origX      + vSin * FX.xRange end
				if FX.yRange		~= nil then Group[2][i].y		 	= Group[2][i].origY      + vCos * FX.yRange end
			end
		else
			vSin  = Sin(now / FX.frequency)
			vCos  = Cos(now / FX.frequency)
			if FX.alphaRange~= nil then 
				alpha 		= Group.origAlpha  + vSin * FX.alphaRange; if alpha > 1.0 then alpha = 1.0 elseif alpha < 0 then alpha = 0  end
				Group.alpha	= alpha 
			end
			if FX.xScaleRange 	~= nil then Group.xScale 	= Group.origXScale + vSin * FX.xScaleRange end
			if FX.yScaleRange 	~= nil then Group.yScale 	= Group.origYScale + vSin * FX.yScaleRange end
			if FX.rotationRange	~= nil then Group.rotation 	= Group.origRot    + vSin * FX.rotationRange end
			if FX.xRange		~= nil then Group.x		 	= Group.origX      + vSin * FX.xRange end
			if FX.yRange		~= nil then Group.y		 	= Group.origY      + vCos * FX.yRange end
		end
		
		-- FINISHED?
		if FX.duration > 0 and now > Timer.endTime then 
			Group:stopAnimation() 
			if FX.autoRemoveText then DeleteText(Group) end
		end
	end

end

----------------------------------------------------------------
-- PRIVATE: MARQUEE ANIMATION
----------------------------------------------------------------
_Marquee = function(event)
	local Group = event.source.Target
	
	Group[2].x = Group[2].x - Group.marqueeSpeed

	if Group[2].x < Group.endX then
		Group[2].x 			= Group[2].x  - Group.endX
		Group.text			= string.sub(Group.text,2)..string.sub(Group.marqueeText,Group.nextCharPos,Group.nextCharPos)
		Group.nextCharPos	= Group.nextCharPos + 1; if Group.nextCharPos > string.len(Group.marqueeText) then Group.nextCharPos = 1 end
		_DrawChars			(Group)
		
		if string.sub (Group.text,1,1) == " " then 
			Group.charW = Charsets[Group.fontName].spaceWidth 
		elseif Group.shadowOffX ~= 0 or Group.shadowOffY ~= 0 then
			Group.charW = Group[2][1][1].width 
		else 
			Group.charW = Group[2][1].width 
		end
		
		Group.endX 			= - (Group.charW + Group.charSpacing)
	end
end
