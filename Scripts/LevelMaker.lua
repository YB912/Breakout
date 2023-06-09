LevelMaker = Class {}

function LevelMaker.createMap(level)
    local bricks = {}
    -- Between 3 and 6 rows and 11 and 15 columns according to the current level
    local numRows = math.max(math.min(6, math.random(math.ceil(level / 2))), 3)
    local numCols = math.max(math.min(15, math.random(math.ceil(level / 2))), 11)
    -- Make sure the number of columns is odd to ensure symmetry
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    local maxMaterial = math.min(4, level % 5 + 2)

    for i = 1, numRows do
        local pattern = i == 1 and math.random(6) or math.random(7)
        if i == 1 and pattern % 2 == 0 then
            pattern = pattern - 1
        end
        -- 1 ==> Solid
        -- 2 ==> Skip
        -- 3 ==> Alternating
        -- 4 ==> Skipping-alternating
        -- 5 ==> Surrounding
        -- 6 ==> Hollow
        -- 7 ==> Empty

        local Material1
        local Material2

        local skipFlag = math.random(2) == 1 and true or false

        local alternatingFlag = math.random(2) == 1 and true or false

        if pattern == 1 or pattern == 2 or pattern == 6 then
            Material1 = math.random(maxMaterial)
        end

        if pattern == 3 or pattern == 4 or pattern == 5 then
            Material1 = math.random(maxMaterial)
            Material2 = math.random(maxMaterial)
            while Material1 == Material2 do
                Material2 = math.random(maxMaterial)
            end
        end

        for j = 1, numCols do
            if (pattern == 2 or pattern == 4) and skipFlag then
                skipFlag = not skipFlag
                goto continue
            else
                skipFlag = not skipFlag
            end

            brick = Brick(((j - 1) * (32 + 2)) + 66 + (15 - numCols) * 17, 40 + i * 18)

            if pattern == 1 or pattern == 2 then
                brick.material = Material1
            end

            if pattern == 3 or pattern == 4 then
                brick.material = alternatingFlag and Material1 or Material2
                alternatingFlag = not alternatingFlag
            end

            if pattern == 5 then
                brick.material = (j == 1 or j == numCols) and Material1 or Material2
            end

            if pattern == 6 then
                if j == 1 or j == math.ceil(numCols / 2) or j == numCols then
                    brick.material = Material1
                else
                    brick.enabled = false
                end
            end

            if pattern == 7 then
                brick.enabled = false
            end

            table.insert(bricks, brick)

            ::continue::
        end
    end

    return bricks
end
