--*********************************************************************************************
--
-- ====================================================================
-- Abstract: Corona SDK Page Curl Effect
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.0
--
-- Copyright (C) 2011 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Published changes made to this software and associated documentation and module files (the
-- "Software") may be used and distributed by ANSCA, Inc. without notification. Modifications
-- made to this software and associated documentation and module files may or may not become
-- part of an official software release. All modifications made to the software will be
-- licensed under these same terms and conditions.
--
--*********************************************************************************************

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- create example pages
local page1 = display.newImageRect( "page1.jpg", display.contentWidth, display.contentHeight )
page1:setReferencePoint( display.TopleftReferencePoint )
page1.x, page1.y = display.contentWidth*0.5, display.contentHeight*0.5

local page2 = display.newImageRect( "page2.jpg", display.contentWidth, display.contentHeight )
page2.x, page2.y = display.contentWidth*0.5, display.contentHeight*0.5
page2:toBack()	-- make sure 2nd page is underneath the first one

local curlPage = display.newImageRect( "curlPage.png", display.contentWidth, display.contentHeight )
curlPage.x, curlPage.y = display.contentWidth*0.5, display.contentHeight*0.5
curlPage.isVisible = false

-- group to hold the page that will be turned (as well as the "curl" page)
local turnGroup = display.newGroup()

-- The following function will turn the page "back"
local function gotoPrevious( curlPage, time )
	local time = time or 500
	
	curlPage.isVisible = true
	local hideCurl = function()
		curlPage.isVisible = false
		turnGroup:setMask( nil )
	end
	transition.to( turnGroup, {maskX=display.contentWidth*0.5+100, time=time } )
	transition.to( curlPage, { rotation=45, x=display.contentWidth+(display.contentWidth*0.10), y=display.contentHeight + (display.contentHeight*0.25), time=time, onComplete=hideCurl })
end

-- The following function will turn the page "forward"
local function gotoNext( currentPage, curlPage, time )
	-- add "pages" to page turning group
	turnGroup:insert( currentPage )
	turnGroup:insert( curlPage )
	
	-- mask should match dimensions of content (e.g. content width/height)
	local curlMask = graphics.newMask( "mask_320x480.png" )	-- iPhone portrait
	--local curlMask = graphics.newMask( "mask_768x1024.png" )	-- iPad portrait
	turnGroup:setMask( curlMask )
	
	-- set initial mask position
	turnGroup.maskX = display.contentWidth * 0.5+100
	turnGroup.maskY = display.contentHeight * 0.5

	-- prepare the page-to-be-turned and the curl image
	currentPage:setReferencePoint( display.BottomLeftReferencePoint )
	curlPage:setReferencePoint( display.BottomRightReferencePoint )
	curlPage.rotation = 45
	curlPage.x = display.contentWidth+(display.contentWidth*0.10)
	curlPage.y = display.contentHeight + (display.contentHeight*0.25)
	curlPage.isVisible = true
	
	-- show pagecurl animation and transition away (next page should already be in position)
	local time = time or 500
	transition.to( turnGroup, { maskX=-display.contentWidth*0.75, time=time } )
	transition.to( curlPage, { rotation=0, x=0, y=display.contentHeight+20, time=time} )
	curlPage.yScale = curlPage.y * 0.2
end

-- initiate page turn after 2 seconds, turn page back after 5 seconds (3 seconds after first turn)
timer.performWithDelay( 2000, function() gotoNext( page1, curlPage, 500 ); end )
timer.performWithDelay( 5000, function() gotoPrevious( curlPage, 500 ); end )