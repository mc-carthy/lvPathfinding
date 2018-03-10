local Grid = require("src.grid")
local bresenham = require("src.lib.los.bresenham")
local JpsGrid = require ("src.lib.jumper.grid")
local JpsPathfinder = require ("src.lib.jumper.pathfinder")

local grid

local jpsMap = {}
local jpsGrid
local jpsFinder
local walkable = 0
local jpsPoints = {}

local mouseX, mouseY = 1, 1
local prevMouseX, prevMouseY = 1, 1
local startX, startY = 1, 1


function love.load()
    grid = Grid.create()
    _createJspMap()
    jpsGrid = JpsGrid(jpsMap) 
    jpsFinder = JpsPathfinder(jpsGrid, 'JPS', walkable) 
    calculateMap()
    printMap()
end

function love.update(dt)
    mouseX, mouseY = grid:worldSpaceToGrid(love.mouse.getPosition())
    if mouseX ~= prevMouseX or mouseY ~= prevMouseY then
        -- local line, success = bresenham.line(startX, startY, mouseX, mouseY, function(x, y)
        --     return grid:isWalkable(x, y)
        -- end)
        calculateMap()
        prevMouseX = mouseX
        prevMouseY = mouseY
    end
    -- grid:setPoints(line, success)
end

function love.draw()
    -- grid:draw()
    _drawJpsMap()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        startX, startY = mouseX, mouseY
    end
end

function _createJspMap()
    for x = 1, grid.xSize do
        jpsMap[x] = {}
        for y = 1, grid.ySize do
            if grid:isWalkable(x, y) then
                jpsMap[x][y] = 0
            else
                jpsMap[x][y] = 1
            end
        end
    end
end

function _drawJpsMap()
    for x = 1, grid.xSize do
        for y = 1, grid.ySize do
            if jpsMap[x][y] == 0 then
                love.graphics.setColor(127, 127, 127)
            else
                love.graphics.setColor(31, 31, 31)
            end
            love.graphics.rectangle('fill', (x - 1) * grid.cellSize, (y - 1) * grid.cellSize, grid.cellDrawSize, grid.cellDrawSize)
        end
    end
    love.graphics.setColor(0, 191, 0, 255)
    for i = 1, #jpsPoints do
        love.graphics.rectangle('fill', (jpsPoints[i][1] - 1) * grid.cellSize, (jpsPoints[i][2] - 1) * grid.cellSize, grid.cellDrawSize, grid.cellDrawSize)
    end
    love.graphics.setColor(255, 255, 255, 255)
    for i = 1, #jpsPoints - 1 do
        love.graphics.line(
            jpsPoints[i][1] * grid.cellSize - grid.cellSize / 2,
            jpsPoints[i][2] * grid.cellSize - grid.cellSize / 2,
            jpsPoints[i + 1][1] * grid.cellSize - grid.cellSize / 2,
            jpsPoints[i + 1][2] * grid.cellSize - grid.cellSize / 2
        )
    end
end

function calculateMap()
    -- Calculates the path, and its length
    local path = jpsFinder:getPath(startX, startY, mouseY, mouseX)
    if path then
    print(('Path found! Length: %.2f'):format(path:getLength()))
        for node, count in path:nodes() do
        print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
        end
        -- local points = {}
        jpsPoints = {}
        for node, _ in path:nodes() do
            table.insert(jpsPoints, { node:getY(), node:getX()})
        end
        -- grid:setPoints(points, true)
    end
end

function printMap()
    for i = 1, #jpsMap do
        for j = 1, #jpsMap[1] do
            io.write(jpsMap[i][j] == 0 and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end