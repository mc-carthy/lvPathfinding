local Grid = require("src.grid")
local bresenham = require("src.lib.los.bresenham")

local grid

local mouseX, mouseY = 0, 0
local startX, startY = 0, 0

function love.load()
    grid = Grid.create()
end

function love.update(dt)
    mouseX, mouseY = grid:worldSpaceToGrid(love.mouse.getPosition())
    local line, success = bresenham.line(startX, startY, mouseX, mouseY, function(x, y)
        return grid:isWalkable(x, y)
    end)
    grid:setPoints(line, success)
end

function love.draw()
    grid:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        startX, startY = mouseX, mouseY
    end
end