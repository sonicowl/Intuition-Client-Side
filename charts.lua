module(..., package.seeall)

-- ==========================================================================================
--
-- Google Chart Class
-- 
-- Created by Graham Ranson of MonkeyDead Studios.
--
-- http://www.grahamranson.co.uk
-- http://www.monkeydeadstudios.com
--
-- 
-- Version: 0.2
-- 
-- Class is MIT Licensed
-- Copyright (C) 2011 MonkeyDead Studios - No Rights Reserved.
--
-- ==========================================================================================

-- Load the relevant LuaSocket modules
local http = require("socket.http")
local ltn12 = require("ltn12")

local googleUrl = "http://chart.apis.google.com/chart?"

local encodeString = function(str)
  if str then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

local downloadChart = function(chart)

	local function networkListener( event )

        if ( event.isError ) then
    		print ( "Network error - download failed" )
        else
            
        end

	end

	if chart.url and chart.type then	 
	
		local download = function()
		
			local time = os.time()
			
			chart.filename = "chart_" .. chart.type .. "_" .. time .. ".png"
			chart.path = system.pathForFile( chart.filename , system.DocumentsDirectory )
			
			local file = io.open( chart.path, "w+b" ) 
			 
			-- Request remote file and save data to local file
			http.request
			{
				url = chart.url, 
				sink = ltn12.sink.file( file ),
			}
			
			native.setActivityIndicator( false )	
			
		--	chart.image = display.newImage( chart.filename, system.DocumentsDirectory, chart.x or 0, chart.y or 0 )
			chart =  chart.filename
			
		end
		
		local showActivityIndicator = function()
			
			native.setActivityIndicator( true )
			timer.performWithDelay(1, download(), 1 )

		end

		showActivityIndicator()
		
		
		
		--return display.loadRemoteImage( chart.url, "GET", networkListener, "chart_" .. chart.type .. "_" .. time .. ".png", system.DocumentsDirectory, chart.x or 0, chart.y or 0 )
	end
	
end

function newQR(params)
	
	local chart = {}
	
	if not params then
		params = {}
	end
	
	chart.type = "qr"
	chart.width = params.width or 200
	chart.height = params.height or chart.width
	chart.data = encodeString(params.data or "")
	chart.encoding = params.encoding or "UTF-8"
	chart.errorCorrectionLevel = params.errorCorrectionLevel or "L"
	chart.margin = params.margin or 4
	chart.x = params.x or 0
	chart.y = params.y or 0
	
	chart.transparency = params.transparency or "a,s,000000" 
	chart.background = params.background or "bg,s,FFFFFF"
	
	chart.url = googleUrl .. "chf=" .. encodeString(chart.transparency .. "|" .. chart.background) 
	chart.url = chart.url .. "&chs=" .. chart.width .. "x" .. chart.height 
	chart.url = chart.url .. "&cht=" .. chart.type 
	chart.url = chart.url .. "&chld=" .. encodeString(chart.errorCorrectionLevel .. "|" .. chart.margin) 
	chart.url = chart.url .. "&chl=" .. chart.data 
	chart.url = chart.url .. "&choe=" .. chart.encoding

	downloadChart(chart)

	return chart
	
end

function newPie(params)

	local chart = {}
	
	if not params then
		params = {}
	end
	
	chart.mode = params.mode or "2d"
	
	if chart.mode == "2d" then
		chart.type = "p"
	elseif chart.mode == "3d" then
		chart.type = "p3"
	elseif chart.mode == "concentric" then
		chart.type = "pc"
	end	
	
	chart.title = params.title or ""
	chart.titleColour = params.titleColour or "000000"
	chart.titleFontSize = params.titleFontSize or 11.5
	chart.data = params.data or ""
	chart.width = 250
	chart.height = 250
	chart.legend = params.legend or ""
	chart.legendPosition = params.legendPosition or "r"
	chart.legendSize = params.legendSize
	chart.labels = params.labels or ""
	chart.radians = params.radians or 1
	chart.margins = params.margins or {0, 0, 0, 0}
	chart.x = params.x or 0
	chart.y = params.y or 0
	chart.scale = params.scale or {0, 100}
	chart.dataColours = params.dataColours or "0000FF"
	
	chart.transparency = "0" 
	chart.background = ""
	
	chart.url = googleUrl .. "chf=bg,s,FFFFFF00"
	
--	chart.url = googleUrl .. "chf=" .. encodeString(chart.transparency .. "|" .. chart.background) 
	chart.url = chart.url .. "&chs=" .. chart.width .. "x" .. chart.height
	chart.url = chart.url .. "&cht=" .. chart.type 
	chart.url = chart.url .. "&chco=" .. encodeString(chart.dataColours) 
	chart.url = chart.url .. "&chds=" .. encodeString(chart.scale[1] .. "," .. chart.scale[2]) 
	chart.url = chart.url .. "&chd=" .. encodeString(chart.data) 
	chart.url = chart.url .. "&chdl=" .. encodeString(chart.legend) 
	chart.url = chart.url .. "&chdlp=" .. chart.legendPosition
	chart.url = chart.url .. "&chp=" .. chart.radians 
	chart.url = chart.url .. "&chtt=" .. encodeString(chart.title) 
	chart.url = chart.url .. "&chts=" .. encodeString(chart.titleColour .. "," .. chart.titleFontSize) 
	chart.url = chart.url .. "&chma=" .. encodeString( chart.margins[1] .. "," .. chart.margins[2] .. "," .. chart.margins[3] .. "," .. chart.margins[4]) 
	
	if chart.legendSize then
		chart.url = chart.url .. "&chl=" .. encodeString(chart.labels .. "|" .. chart.legendSize[1] .. "," .. chart.legendSize[2])
	else
		chart.url = chart.url .. "&chl=" .. encodeString(chart.labels)
	end
	
	downloadChart(chart)

	return chart
	
end


function newLine(params)

	local chart = {}
	
	if not params then
		params = {}
	end
	
	chart.mode = params.mode or "standard"
	
	if chart.mode == "standard" then
		chart.type = "lc"
	elseif chart.mode == "spark" then
		chart.type = "ls"
	elseif chart.mode == "xy" then
		chart.type = "lxy"
	end	
	
	chart.title = params.title or ""
	chart.titleColour = params.titleColour or "000000"
	chart.titleFontSize = params.titleFontSize or 11.5
	chart.data = params.data or ""
	chart.width = params.width or 200
	chart.height = params.height or chart.width
	chart.legend = params.legend or ""
	chart.legendPosition = params.legendPosition or "r"
	chart.legendSize = params.legendSize
	chart.labels = params.labels or ""
	chart.margins = params.margins or {0, 0, 0, 0}
	chart.x = params.x or 0
	chart.y = params.y or 0
	chart.scale = params.scale or {0, 100}
	chart.dataColours = params.dataColours or "0000FF"
	chart.dataStyle = params.dataStyle or ""
	
	chart.axis = params.axis or ""
	chart.axisLabels = params.axisLabels or ""
	chart.axisLabelPositions = params.axisLabelPositions or ""
	
	chart.transparency = params.transparency or "a,s,000000" 
	chart.background = params.background or "bg,s,FFFFFF"
	
	chart.url = googleUrl .. "chf=" .. encodeString(chart.transparency .. "|" .. chart.background) 
	chart.url = chart.url .. "&chs=" .. chart.width .. "x" .. chart.height
	chart.url = chart.url .. "&cht=" .. chart.type 
	chart.url = chart.url .. "&chco=" .. encodeString(chart.dataColours) 
	chart.url = chart.url .. "&chd=" .. encodeString(chart.data) 
	chart.url = chart.url .. "&chdl=" .. encodeString(chart.legend) 
	chart.url = chart.url .. "&chdlp=" .. chart.legendPosition
	chart.url = chart.url .. "&chls=" .. encodeString(chart.dataStyle)
	chart.url = chart.url .. "&chts=" .. encodeString(chart.titleColour .. "," .. chart.titleFontSize) 
	chart.url = chart.url .. "&chma=" .. encodeString(chart.margins[1] .. "," .. chart.margins[2] .. "," .. chart.margins[3] .. "," .. chart.margins[4]) 
	chart.url = chart.url .. "&chtt=" .. encodeString(chart.title) 
   
   	if chart.axisLabels ~= "" then
   		
   		chart.url = chart.url .. "&chxt=" .. chart.axis
   		chart.url = chart.url .. "&chxl=" .. encodeString(chart.axisLabels) 
   		chart.url = chart.url .. "&chxp="  .. encodeString(chart.axisLabelPositions)
   	
   	else
 
		if chart.legendSize then
			chart.url = chart.url .. "&chl=" .. encodeString(chart.labels .. "|" .. chart.legendSize[1] .. "," .. chart.legendSize[2])
		else
			chart.url = chart.url .. "&chl=" .. encodeString(chart.labels)
		end
   	
   	end

	downloadChart(chart)
	
	return chart
	
end

function newChart(params)
	
	if params.type == "qr" then		
		return newQR(params)
	elseif params.type == "pie" then		
		return newPie(params)	
	elseif params.type == "line" then		
		return newLine(params)	
	end

end	


