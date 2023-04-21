PaddleSelectState = Class { __includes = BaseState }

local hovered = 0
-- 0 ==> none
-- 1 ==> left arrow
-- 2 ==> confirm
-- 3 ==> right arrow
local currentPaddle = 1

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:onClick(button)
    if button == 1 then
        if hovered == 1 then
            PaddleSelectState:changeSelection('left')
        elseif hovered == 2 then
            PaddleSelectState:confirmSelection()
        elseif hovered == 3 then
            PaddleSelectState:changeSelection('right')
        end
    elseif button == 2 then
        gSounds['wallHit']:play()
        gStateMachine:change('start', {
            highScores = loadHighScores()
        })
    end
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        PaddleSelectState:changeSelection('left')
    elseif love.keyboard.wasPressed('right') then
        PaddleSelectState:changeSelection('right')
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        PaddleSelectState:confirmSelection()
    end

    if love.mouse.getY() >= 350 and love.mouse.getY() < 395 then
        if love.mouse.getX() >= 445 and love.mouse.getX() < 500 then
            hovered = 1
            love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
        elseif love.mouse.getX() >= 545 and love.mouse.getX() < 735 then
            hovered = 2
            love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
        elseif love.mouse.getX() >= 780 and love.mouse.getX() < 835 then
            hovered = 3
            love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
        else
            hovered = 0
            love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
        end
    else
        hovered = 0
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
    end

    if love.keyboard.wasPressed('escape') then
        gSounds['wallHit']:play()
        gStateMachine:change('start', {
            highScores = loadHighScores()
        })
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf("Select your paddle", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if currentPaddle == 1 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 1)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 2 - 100,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 - 70)

    love.graphics.setColor(1, 1, 1, 1)

    if currentPaddle == 3 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 1)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH / 2 + 68,
        VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 - 70)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(gTextures['paddles'], gFrames['paddles'][2 + 3 * (currentPaddle - 1)],
        VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 - 62)

    love.graphics.setFont(gFonts['scores'])
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.printf("(Press Enter to continue)", 0, VIRTUAL_HEIGHT / 3 + 130,
        VIRTUAL_WIDTH, 'center')
end

function PaddleSelectState:changeSelection(direction)
    if direction == 'left' then
        if currentPaddle == 1 then
            gSounds['noSelect']:play()
        else
            currentPaddle = currentPaddle - 1
            gSounds['select']:play()
        end
    elseif direction == 'right' then
        if currentPaddle == 3 then
            gSounds['noSelect']:play()
        else
            currentPaddle = currentPaddle + 1
            gSounds['select']:play()
        end
    end
end

function PaddleSelectState:confirmSelection()
    gSounds['confirm']:play()
        gStateMachine:change('serve', {
            paddle = Paddle(currentPaddle),
            bricks = LevelMaker.createMap(1),
            health = Health(),
            score = 0,
            highScores = self.highScores,
            level = 1
        })
end

