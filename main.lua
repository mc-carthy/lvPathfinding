local Grid = require("src.grid")
local bresenham = require("src.lib.los.bresenham")
local jsp = require("src.lib.pathfinding.jsp")

local grid

local mouseX, mouseY = 1, 1
local prevMouseX, prevMouseY = 1, 1
local startX, startY = 1, 1

function love.load()
    grid = Grid.create()
    path = jsp.create(grid)
end

function love.update(dt)
    mouseX, mouseY = grid:worldSpaceToGrid(love.mouse.getPosition())
    if mouseX ~= prevMouseX or mouseY ~= prevMouseY then
        -- local line, success = bresenham.line(startX, startY, mouseX, mouseY, function(x, y)
        --     return grid:isWalkable(x, y)
        -- end)
        -- TODO: Figure out why x & y are reversed
        path:calculateMap(startX, startY, mouseY, mouseX)
        prevMouseX = mouseX
        prevMouseY = mouseY
        grid:setPoints(path.points, true)
    end
end

function love.draw()
    grid:draw()
    love.graphics.setColor(255, 255, 255, 255)
    for i = 1, #path.points - 1 do
        love.graphics.line(
            path.points[i][1] * grid.cellSize - grid.cellSize / 2,
            path.points[i][2] * grid.cellSize - grid.cellSize / 2,
            path.points[i + 1][1] * grid.cellSize - grid.cellSize / 2,
            path.points[i + 1][2] * grid.cellSize - grid.cellSize / 2
        )
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        startX, startY = mouseY, mouseX
    end
end