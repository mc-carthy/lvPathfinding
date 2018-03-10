local Grid = require("src.grid")
local bresenham = require("src.lib.los.bresenham")

local grid

local mouseX, mouseY = 1, 1
local prevMouseX, prevMouseY = 1, 1
local startX, startY = 1, 1

function love.load()
    grid = Grid.create()
end

function love.update(dt)
    mouseX, mouseY = grid:worldSpaceToGrid(love.mouse.getPosition())
    if mouseX ~= prevMouseX or mouseY ~= prevMouseY then
        -- local line, success = bresenham.line(startX, startY, mouseX, mouseY, function(x, y)
        --     return grid:isWalkable(x, y)
        -- end)
        prevMouseX = mouseX
        prevMouseY = mouseY
        grid:getPath(startX, startY, mouseX, mouseY)
    end
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