-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local slashLine = require("slashLine")
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

display.setDefault("background", 230/255, 232/255, 237/255)
local score, life = 0, 10  

local track = audio.loadStream("sounds/track.mp3")
local cut = audio.loadSound("sounds/cut.wav")
local gameMusicChannel = audio.play( track, { loops = -1, channel=1 } )
audio.setVolume( 0.4, { channel=1 } )

local scoreOptions = 
{
	text = "Score: " .. score,
	x = 100,
	y = -24,
	width = display.contentWidth/2,
	font = native.systemFont,   
	fontSize = 20,
	align = "left"  -- Alignment parameter
}

local scoreBoard = display.newText(scoreOptions)
scoreBoard:setFillColor( 0.2, 0.2, 0.2 )

local lifeOptions = 
{
	text = "Life: " .. life .. "/10",
	x = display.contentWidth/2 + 60,
	y = -24,
	width = display.contentWidth/2,
	font = native.systemFont,   
	fontSize = 20,
	align = "right"  -- Alignment parameter
}

local lifeBoard = display.newText(lifeOptions)
lifeBoard:setFillColor( 0.2, 0.2, 0.2 )

local function loser()
	local function onComplete( event )
		function restartStats()
			score = 0
			life = 10
			endGame = false
			scoreBoard.text = "Score: " .. score
			lifeBoard.text = "Life: " .. life .. "/10"
		end
		if ( event.action == "clicked" ) then
			local i = event.index
			if ( i == 1 ) then
				restartStats()
				composer.removeScene( "level1" )
				composer.gotoScene( "level1" )
			elseif ( i == 2 ) then
				restartStats()
				composer.gotoScene( "menu", "fade", 500 )
				composer.removeScene( "level1" )
			end
		end
	end
	native.showAlert( "Ohh no.", "You lose, dude. Choose what you wanna do.", { "Play Again", "Back to menu" }, onComplete )
end

local function randomColor()
	return unpack({
		math.random(100, 225)/255,
		math.random(100, 225)/255,
		math.random(100, 225)/255,
		1
	})
end
-- display.setDefault(randomColor())
-- load menu screen
local function userTap(event)
	if(event.target.alpha == 1) then
		score = score + 10
		audio.play(cut, {channel = 2})
	end
	transition.fadeOut( event.target, { time=200 } )
	print("Score: " .. score)
	scoreBoard.text = "Score: " .. score

end

local function getPostionByQuadrant(quadrant)
	if quadrant == 1 then
		return {
				x=-25, 
				y=math.random(40, display.contentHeight-40)
			}
	elseif quadrant == 2 then
		return {
				x=math.random(40, display.contentWidth-40),
				y=-25
			}
	elseif quadrant == 3 then
		return {
				x=display.contentWidth + 25,
				y=math.random(40, display.contentHeight-40)
			}
	elseif quadrant == 4 then
		return {
				x=math.random(40, display.contentWidth-40),
				y=display.contentHeight+25
			}
	end
end

local function getQuadrant()
	local quadrant = math.random(1,4)
	if quadrant == 1 then
		return {position= getPostionByQuadrant(1), destiny= {2,3,4}}
	elseif quadrant == 2 then
		return {position= getPostionByQuadrant(2), destiny= {1,3,4}}
	elseif quadrant == 3 then
		return {position= getPostionByQuadrant(3), destiny= {1,2,4}}
	elseif quadrant == 4 then
		return {position= getPostionByQuadrant(4), destiny= {1,2,3}}
	end
end

local function getGameLoop()
	if score <= 1600 then
		return 2000 - score
	end
	return 400
end

local function destroyBall(obj)
	return function ()
		if obj.alpha == 1 then
			if life > 0 then
				life = life - 1
				lifeBoard.text = "Life: " .. life .. "/10"
			end
			if life == 0 then
				endGame = true
				loser()
			end
		end
		if obj ~= nil then
			obj:removeSelf()
			obj = nil
		end
	end
end
local function newBall()
	local start = getQuadrant()
	local final = getPostionByQuadrant(start.destiny[math.random(1,3)])
	local circle = display.newCircle(start.position.x,start.position.y, math.random(20, 35) )
	circle:setFillColor(randomColor())
	circle:toBack()

	transition.moveTo( circle, { 
		x=final.x, 
		y=final.y, 
		time=2000,
		onComplete=destroyBall(circle)
	} )

	circle:addEventListener( "tap", userTap )
	-- timer.performWithDelay(getGameLoop(), newBall)
end

-- newBall()


local function newRect()
	local start = getQuadrant()
	local final = getPostionByQuadrant(start.destiny[math.random(1,3)])
	local rect = display.newRoundedRect( start.position.x, start.position.y, math.random(50, 100), 24, 12 )
	local angle = math.atan2(start.position.y - final.y, start.position.x - final.x) * 180 / math.pi
	rect:rotate(angle)
	rect:setFillColor(randomColor())
	rect:toBack()
	transition.moveTo( rect, { 
		x=final.x, 
		y=final.y, 
		time=2000,
		onComplete=destroyBall(rect)
	} )
	rect:addEventListener( "touch", userTap )
	--  timer.performWithDelay(getGameLoop()+50, newRect)
end


local function start()
	if endGame then
		return
	end
	local toThrow = {1,1,1,1,2}
	local elements = math.random(1,5)
	for i = 1, toThrow[elements] do
		local shape = math.random(1,2)
		if shape == 1 then
			newBall()
		elseif shape ==2 then
			newRect()
		end
	end
	timer.performWithDelay(getGameLoop(), start)
end


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view
	sceneGroup:insert(lifeBoard)
	sceneGroup:insert(scoreBoard)
	-- sceneGroup:insert(gameMusicChannel)
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
		start()
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
		-- physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene