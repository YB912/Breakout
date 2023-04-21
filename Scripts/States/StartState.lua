StartState = Class {
    __includes = BaseState
}

local selected = 1
local confirmed = 0
local enteredButtonArea = false

function StartState:enter(enteringParams)
    self.highScores = enteringParams.highScores
    love.mouse.setVisible(true)
    gSounds['game']:stop()
    gSounds['menu']:play()
end

function StartState:update(dt)

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        selected = selected == 1 and 2 or 1
        gSounds['paddleHit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()

        if selected == 1 then
            confirmed = 1
        else
            confirmed = 2
        end
    end

    if confirmed == 1 then
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
        gStateMachine:change('paddleSelect', {
            highScores = self.highScores
        })
    elseif confirmed == 2 then
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
        gStateMachine:change('highScore', {
            highScores = self.highScores
        })
    end

    confirmed = 0

    if love.mouse.getX() >= VIRTUAL_WIDTH - 140 and love.mouse.getX() < VIRTUAL_WIDTH + 135 then
        
        if love.mouse.getY() >= VIRTUAL_HEIGHT and love.mouse.getY() < VIRTUAL_HEIGHT + 65 then
            if not enteredButtonArea then
                selected = 1
                gSounds['paddleHit']:play()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end
            enteredButtonArea = true
        elseif love.mouse.getY() >= VIRTUAL_HEIGHT + 120 and love.mouse.getY() < VIRTUAL_HEIGHT + 190 then
            if not enteredButtonArea then
                selected = 2
                gSounds['paddleHit']:play()
                love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
            end
            enteredButtonArea = true
        else
            love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
            enteredButtonArea = false
        end
    else
        love.mouse.setCursor(love.mouse.getSystemCursor('arrow'))
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
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)

    if selected == 1 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], 400, VIRTUAL_HEIGHT / 2 + 5)
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    end
    love.graphics.printf('Start Game', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)

    if selected == 2 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], 400, VIRTUAL_HEIGHT / 2 + 65)
        love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    end
    love.graphics.printf('High Scores', 0, VIRTUAL_HEIGHT / 2 + 60, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
end

function StartState:onClick(button)
    if button == 1 then
        if enteredButtonArea then
            gSounds['confirm']:play()
            if selected == 1 then
                confirmed = 1
            else
                confirmed = 2
            end
        end
    end
end