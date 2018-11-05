---------------------------------------------------------------------------
-- function and values for drawing slashing line --
---------------------------------------------------------------------------
local composer = require("composer")
local maxPoints = 5
local lineThickness = 7
local endPoints = {}

local function movePoint(event)
	        -- Insert a new point into the front of the array
        table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 
 
        -- Remove any excessed points
        if(#endPoints > maxPoints) then 
                table.remove(endPoints)
        end
 
        for i,v in ipairs(endPoints) do
                local line = display.newLine(v.x, v.y, event.x, event.y)
      		  line.strokeWidth = lineThickness
                transition.to(line, { alpha = 0, strokeWidth = 0, onComplete = function(event) line:removeSelf() end})                
        end
 
	if event.phase == "ended" then
		touchEnd = 1
		while(#endPoints > 0) do
			table.remove(endPoints)
		end

	elseif event.phase == "began" then
		touchEnd = 0
	end

end
Runtime:addEventListener("touch", movePoint)
