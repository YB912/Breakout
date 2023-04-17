LevelMaker = Class {}

function LevelMaker.createMap(level)
    local bricks = {}
    local numRows = math.random(1, 7)
    local numCols = math.random(8, 15)

    for i = 1, numRows do
        for j = 1, numCols do
            brick = Brick(((j - 1) * (32 + 2)) + 66 + (15 - numCols) * 17, 28 + i * 18)
            table.insert(bricks, brick)
        end
    end

    return bricks
end
