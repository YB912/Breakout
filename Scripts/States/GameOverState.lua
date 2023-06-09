GameOverState = Class { __includes = BaseState }

local leftClicked = false

function GameOverState:enter(enteringParams)
    self.score = enteringParams.score
    self.highScores = enteringParams.highScores
    self.health = enteringParams.health

    gSounds['score']:play()
end

function GameOverState:update(dt)
    self.health:update(dt)
    if leftClicked or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('escape') then
        local highScore = false
        local scoreIndex = 11

        -- Check if the score is among the top 10 or not
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

    leftClicked = false
end

function GameOverState:render()
    self.health:render()
    love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Left-click or press enter', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
end

-- Event handler for clicking in the play state
function GameOverState:onClick(button)
    if button == 1 then
        leftClicked = true
    end
end
