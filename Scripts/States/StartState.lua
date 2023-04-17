StartState = Class {
    __includes = BaseState
}

local selected = 1

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        selected = selected == 1 and 2 or 1
        gSounds['paddleHit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if selected == 1 then
            gStateMachine:change('serve', {
                paddle = Paddle(1),
                bricks = LevelMaker.createMap(),
                health = 3,
                score = 0
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.printf('Breakout', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(30 / 255, 30 / 255, 30 / 255, 1)

    if selected == 1 then
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
        love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], 400, VIRTUAL_HEIGHT / 2 + 5)
    end
    love.graphics.printf('Start Game', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(30 / 255, 30 / 255, 30 / 255, 1)

    if selected == 2 then
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
        love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], 400, VIRTUAL_HEIGHT / 2 + 65)
    end
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(30 / 255, 30 / 255, 30 / 255, 1)
end
