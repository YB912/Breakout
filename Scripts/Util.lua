function GenerateQuads(spriteSheet, tileWidth, tileHeight)
    local sheetWidth = spriteSheet:getWidth() / tileWidth
    local sheetHeight = spriteSheet:getHeight() / tileHeight

    local spriteCount = 1
    local sprites = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            sprites[spriteCount] =
                love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth,
                    tileHeight, spriteSheet:getDimensions())
            spriteCount = spriteCount + 1
        end
    end

    return sprites
end

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function GenerateQuadsPaddles(spriteSheet)
    local y = 0
    local counter = 1
    local quads = {}

    for i = 0, 2 do
        -- The small paddle
        quads[counter] = love.graphics.newQuad(0, y, 64, 16, spriteSheet:getDimensions())
        counter = counter + 1
        -- The meduim paddle
        quads[counter] = love.graphics.newQuad(64, y, 96, 16, spriteSheet:getDimensions())
        counter = counter + 1
        -- The large paddle
        quads[counter] = love.graphics.newQuad(160, y, 128, 16, spriteSheet:getDimensions())
        counter = counter + 1

        y = y + 16
    end

    return quads
end

function GenerateQuadsBricks(spriteSheet)
    return table.slice(GenerateQuads(spriteSheet, 32, 16), 1, 16)
end

function GenerateQuadsArrows(spriteSheet)
    return table.slice(GenerateQuads(spriteSheet, 32, 32), 1, 2)
end

