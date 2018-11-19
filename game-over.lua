-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playAgainBtn
local menuBtn

-- 'onRelease' event listener for playAgainBtn
local function onPlayAgainBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for menuBtn
local function onMenuBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	display.setDefault("background", 230/255, 230/255, 230/255)
	
	-- create/position logo/title image on upper-half of the screen
	local scoreOptions = {
		text = "You have scored " .. event.params.score .. ".\nCongrats!",
		x = display.contentCenterX,
		y = display.contentCenterY - 85,
		width = display.contentWidth - display.contentWidth/3,
		font = native.systemFont,   
		fontSize = 28,
		align = "center"  -- Alignment parameter
	}
	local scoreBoard = display.newText(scoreOptions)
	scoreBoard:setFillColor( 0.2, 0.2, 0.2 )
	-- create a widget button (which will loads level1.lua on release)
	playAgainBtn = widget.newButton{
		label="Play Again",
		labelColor = { default={0}, over={128} },
		shape = "roundedRect",
		cornerRadius = 8,
        fillColor = { default={200/255, 200/255, 200/255}, over={100/255, 100/255, 100/255} },
		width=154, height=40,
		onRelease = onPlayAgainBtnRelease	-- event listener function
	}
	playAgainBtn.x = display.contentCenterX
	playAgainBtn.y = display.contentHeight - 145
	
	menuBtn = widget.newButton{
		label="Menu",
		labelColor = { default={0}, over={128} },
		shape = "roundedRect",
		cornerRadius = 8,
        fillColor = { default={200/255, 200/255, 200/255}, over={100/255, 100/255, 100/255} },
		width=154, height=40,
		onRelease = onMenuBtnRelease	-- event listener function
	}
	menuBtn.x = display.contentCenterX
	menuBtn.y = display.contentHeight - 85
	
	-- all display objects must be inserted into group
	sceneGroup:insert( scoreBoard )
	sceneGroup:insert( playAgainBtn )
	sceneGroup:insert( menuBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playAgainBtn then
		playAgainBtn:removeSelf()	-- widgets must be manually removed
		playAgainBtn = nil
	end
	if menuBtn then
		menuBtn:removeSelf()	-- widgets must be manually removed
		menuBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene