GameOverState = Class { __includes = BaseState }

function GameOverState:enter(enteringParams)
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.health = enteringParams.health
end

function GameOverState:update(dt)
    self.health:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false
        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['highScore']:play()
            gStateMachine:change('entry', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            })
        else
            gStateMachine:change('start', {
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    self.health:render()
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
end
