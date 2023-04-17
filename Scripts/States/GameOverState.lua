GameOverState = Class { __includes = BaseState }

function GameOverState:enter(enteringParams)
    self.score = enteringParams.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setColor(80 / 255, 120 / 255, 230 / 255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
end